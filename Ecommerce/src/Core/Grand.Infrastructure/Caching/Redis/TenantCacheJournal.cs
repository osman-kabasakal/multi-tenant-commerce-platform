using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using Grand.Infrastructure.Events;
using Grand.Infrastructure.MultiTenant;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using StackExchange.Redis;

namespace Grand.Infrastructure.Caching.Redis;

public sealed record CacheReadStamp(string Epoch, long Revision);
public sealed record ClientCacheNotice(string CorrelationId, string Revision);

/// <summary>Owned, bounded cache facts and client dependencies; Redis values never contain model data.</summary>
public sealed class TenantCacheJournal
{
    private const int LifetimeSeconds = 24 * 60 * 60;
    private const int MaximumFacts = 5000;
    private const int MaximumDependencies = 256;
    private const int MaximumCorrelations = 512;
    private readonly IConnectionMultiplexer _redis;
    private readonly IHttpContextAccessor _http;
    private readonly ITenantIdentityAccessor _tenant;
    private readonly string _deployment;
    public bool Enabled { get; }

    public TenantCacheJournal(IConnectionMultiplexer redis, IConfiguration config, IHttpContextAccessor http, ITenantIdentityAccessor tenant)
    {
        _redis = redis; _http = http; _tenant = tenant;
        Enabled = config.GetValue<bool>("Provisioning:ManagedRuntime") || config.GetValue<bool>("LocalDemo:Enabled");
        _deployment = config["Redis:RedisPubSubChannel"] ?? "";
        if (Enabled && !config.GetValue<bool>("Redis:RedisPubSubEnabled"))
            throw new InvalidOperationException("Managed cache tracking requires the configured Redis message transport.");
        if (Enabled && !Regex.IsMatch(_deployment, "^[a-z][a-z0-9-]{2,39}$", RegexOptions.CultureInvariant))
            throw new InvalidOperationException("Managed cache tracking requires a deployment-specific Redis channel.");
    }

    public string CurrentStore()
    {
        string store = null;
        if (_http.HttpContext?.Items.TryGetValue("StoreId", out var item) == true) store = item?.ToString();
        store = string.IsNullOrEmpty(store) ? _tenant.TenantId : store;
        if (!string.IsNullOrEmpty(store)) Identity(store);
        return store;
    }

    public string CurrentCustomer()
    {
        if (_http.HttpContext?.Items.TryGetValue("CurrentCustomerId", out var item) != true || string.IsNullOrEmpty(item?.ToString())) return null;
        var customer = item.ToString(); Identity(customer); return customer;
    }

    private static void Identity(string value)
    {
        if (string.IsNullOrEmpty(value) || !Regex.IsMatch(value, "^[A-Za-z0-9_-]{1,128}$", RegexOptions.CultureInvariant))
            throw new InvalidOperationException("Use a server-resolved store/customer identity.");
    }
    private string Prefix(string store) { Identity(store); return "commerce:" + _deployment + ":cache:v1:{" + store + "}:"; }
    private static string Owner(string customer) { Identity(customer); return Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(customer))).ToLowerInvariant(); }
    private RedisKey[] StateKeys(string store)
    {
        var p = Prefix(store); return [p + "epoch", p + "sequence", p + "cutoff", p + "facts", p + "fact-order"];
    }
    private const string StatePrelude = """
        local epoch=redis.call('GET',KEYS[1])
        local sequence=redis.call('GET',KEYS[2])
        local cutoff=redis.call('GET',KEYS[3])
        if epoch and (not sequence or not cutoff or (tonumber(sequence)>0 and (redis.call('EXISTS',KEYS[4])==0 or redis.call('EXISTS',KEYS[5])==0))) then epoch=nil end
        if not epoch then
          redis.call('DEL',KEYS[2],KEYS[3],KEYS[4],KEYS[5])
          epoch=ARGV[1];redis.call('SET',KEYS[1],epoch);redis.call('SET',KEYS[2],0);redis.call('SET',KEYS[3],0)
        end
        for i=1,5 do redis.call('EXPIRE',KEYS[i],ARGV[2]) end
        """ + "\n";

    private sealed record State(CacheReadStamp Stamp, long Cutoff, HashEntry[] Facts);
    public async Task<CacheReadStamp> ObserveAsync(string store)
    {
        var result = (RedisResult[])await _redis.GetDatabase().ScriptEvaluateAsync(StatePrelude + "return {epoch,redis.call('GET',KEYS[2]) or '0'}",
            StateKeys(store), [Guid.NewGuid().ToString("N"), LifetimeSeconds]).ConfigureAwait(false);
        return new((string)result[0], (long)result[1]);
    }

    public async Task InvalidateAsync(string store, string key, CacheEvent kind)
    {
        if (kind is not (CacheEvent.RemoveKey or CacheEvent.RemovePrefix) || !key.StartsWith(store + ".", StringComparison.Ordinal) || key.Length > 4096)
            throw new InvalidOperationException("Record only a qualified cache invalidation for the current store.");
        var script = StatePrelude + """
            local revision=redis.call('INCR',KEYS[2])
            local field=ARGV[3]..ARGV[4]
            redis.call('HSET',KEYS[4],field,revision);redis.call('ZADD',KEYS[5],revision,field)
            local excess=redis.call('ZCARD',KEYS[5])-tonumber(ARGV[5])
            if excess>0 then
              local old=redis.call('ZRANGE',KEYS[5],0,excess-1,'WITHSCORES')
              local cutoff=tonumber(redis.call('GET',KEYS[3]) or '0')
              for i=1,#old,2 do
                redis.call('HDEL',KEYS[4],old[i]);cutoff=math.max(cutoff,tonumber(old[i+1]))
              end
              redis.call('ZREMRANGEBYRANK',KEYS[5],0,excess-1);redis.call('SET',KEYS[3],cutoff)
            end
            for i=1,5 do redis.call('EXPIRE',KEYS[i],ARGV[2]) end
            return revision
            """;
        await _redis.GetDatabase().ScriptEvaluateAsync(script, StateKeys(store),
            [Guid.NewGuid().ToString("N"), LifetimeSeconds, kind == CacheEvent.RemoveKey ? "K" : "P", key, MaximumFacts]).ConfigureAwait(false);
    }

    private async Task<State> ReadState(string store)
    {
        var keys = StateKeys(store); var db = _redis.GetDatabase();
        // One script captures the epoch/revision/cutoff and matching fact set consistently.
        var result = (RedisResult[])await db.ScriptEvaluateAsync(StatePrelude + "return {epoch,redis.call('GET',KEYS[2]) or '0',redis.call('GET',KEYS[3]) or '0',redis.call('HGETALL',KEYS[4])}",
            keys, [Guid.NewGuid().ToString("N"), LifetimeSeconds]).ConfigureAwait(false);
        var data = (RedisResult[])result[3]; var facts = new List<HashEntry>();
        for (var i = 0; i < data.Length; i += 2) facts.Add(new((string)data[i], (string)data[i + 1]));
        return new(new((string)result[0], (long)result[1]), (long)result[2], facts.ToArray());
    }

    private static long DirtyRevision(State state, string key, CacheReadStamp stamp)
    {
        if (stamp == null || stamp.Epoch != state.Stamp.Epoch || stamp.Revision > state.Stamp.Revision || stamp.Revision < state.Cutoff)
            return Math.Max(1, state.Stamp.Revision);
        long dirty = 0;
        foreach (var entry in state.Facts)
        {
            var field = entry.Name.ToString();
            if (!long.TryParse(entry.Value.ToString(), out var revision)) return Math.Max(1, state.Stamp.Revision);
            if (revision <= stamp.Revision) continue;
            if ((field.StartsWith('K') && key.Equals(field[1..], StringComparison.Ordinal)) ||
                (field.StartsWith('P') && key.StartsWith(field[1..], StringComparison.OrdinalIgnoreCase))) dirty = Math.Max(dirty, revision);
        }
        return dirty;
    }

    public async Task<bool> IsFreshAsync(string store, string key, CacheReadStamp stamp)
    {
        var observed = await ObserveAsync(store).ConfigureAwait(false);
        if (stamp != null && stamp == observed) return true;
        return DirtyRevision(await ReadState(store).ConfigureAwait(false), key, stamp) == 0;
    }

    public async Task TrackCurrentAsync(string store, string key, CacheReadStamp stamp)
    {
        var customer = CurrentCustomer();
        if (customer == null || _http.HttpContext?.Items.TryGetValue("CorrelationId", out var value) != true || !Guid.TryParse(value?.ToString(), out var id)) return;
        await TrackAsync(store, customer, id.ToString("D"), key, stamp).ConfigureAwait(false);
    }

    public async Task TrackAsync(string store, string customer, string correlation, string key, CacheReadStamp stamp)
    {
        if (!Guid.TryParse(correlation, out var id) || id == Guid.Empty || key.Length > 4096 || !key.StartsWith(store + ".", StringComparison.Ordinal))
            throw new ArgumentException("Track a bounded owned cache dependency and correlation.");
        var p = Prefix(store); var owner = Owner(customer); var prefix = p + "correlation:" + owner + ":";
        var script = """
            local original=redis.call('HGET',KEYS[1],'$owner')
            if original and original~=ARGV[1] then return redis.error_reply('CORRELATION_OWNER_CHANGED') end
            redis.call('HSET',KEYS[1],'$owner',ARGV[1],'$id',ARGV[2])
            local field='k:'..ARGV[3];local previous=redis.call('HGET',KEYS[1],field)
            if previous then
              if string.sub(previous,1,32)~=string.sub(ARGV[4],1,32) then redis.call('HSET',KEYS[1],'$mixed',1)
              elseif tonumber(string.sub(previous,34))>tonumber(string.sub(ARGV[4],34)) then redis.call('HSET',KEYS[1],field,ARGV[4]) end
            elseif redis.call('HLEN',KEYS[1])<tonumber(ARGV[6])+2 then redis.call('HSET',KEYS[1],field,ARGV[4])
            else redis.call('HSET',KEYS[1],'$overflow',1) end
            local t=redis.call('TIME');local now=tonumber(t[1])*1000+math.floor(tonumber(t[2])/1000)
            local latest=redis.call('ZRANGE',KEYS[2],-1,-1,'WITHSCORES')
            if #latest>0 then now=math.max(now,tonumber(latest[2])+1) end
            redis.call('ZADD',KEYS[2],now,ARGV[5]);redis.call('ZADD',KEYS[3],'NX',0,ARGV[1])
            local excess=redis.call('ZCARD',KEYS[2])-tonumber(ARGV[7])
            if excess>0 then
              for _,old in ipairs(redis.call('ZRANGE',KEYS[2],0,excess-1)) do redis.call('DEL',ARGV[8]..old) end
              redis.call('ZREMRANGEBYRANK',KEYS[2],0,excess-1)
            end
            for i=1,3 do redis.call('EXPIRE',KEYS[i],ARGV[9]) end
            return 1
            """;
        await _redis.GetDatabase().ScriptEvaluateAsync(script, [prefix + id.ToString("N"), p + "owner:" + owner, p + "owners"],
            [customer, id.ToString("D"), key, stamp.Epoch + ":" + stamp.Revision.ToString(CultureInfo.InvariantCulture), id.ToString("N"),
             MaximumDependencies, MaximumCorrelations, prefix, LifetimeSeconds]).ConfigureAwait(false);
    }

    private static CacheReadStamp Parse(string text)
    {
        if (text.Length < 34 || text[32] != ':' || !Guid.TryParseExact(text[..32], "N", out _) || !long.TryParse(text[33..], out var revision) || revision < 0) return null;
        return new(text[..32], revision);
    }

    private string DirtyToken(State state, HashEntry[] record, string customer)
    {
        var values = record.ToDictionary(x => x.Name.ToString(), x => x.Value.ToString(), StringComparer.Ordinal);
        if (values.GetValueOrDefault("$owner") != customer || !values.TryGetValue("$id", out var original) || !Guid.TryParse(original, out _)) return "missing";
        if (values.ContainsKey("$overflow") || values.ContainsKey("$mixed")) return state.Stamp.Epoch + ":incomplete";
        var dependencies = values.Where(x => x.Key.StartsWith("k:", StringComparison.Ordinal)).ToArray();
        if (dependencies.Length == 0) return "missing";
        long dirty = 0;
        foreach (var entry in dependencies) dirty = Math.Max(dirty, DirtyRevision(state, entry.Key[2..], Parse(entry.Value)));
        return dirty > 0 ? state.Stamp.Epoch + ":" + dirty.ToString(CultureInfo.InvariantCulture) : null;
    }

    public async Task<IReadOnlyList<string>> StaleAsync(string store, string customer, IReadOnlyList<string> correlations)
    {
        if (correlations.Count > 100) throw new ArgumentException("Check at most one hundred client correlations per request.");
        var p = Prefix(store) + "correlation:" + Owner(customer) + ":"; var db = _redis.GetDatabase(); var state = await ReadState(store).ConfigureAwait(false);
        var stale = new List<string>();
        foreach (var input in correlations.Distinct(StringComparer.Ordinal))
        {
            if (!Guid.TryParse(input, out var id) || id == Guid.Empty || input.Length > 64) { stale.Add(input); continue; }
            var record = await db.HashGetAllAsync(p + id.ToString("N")).ConfigureAwait(false);
            if (DirtyToken(state, record, customer) != null) stale.Add(input);
        }
        return stale;
    }

    public Task<IReadOnlyList<ClientCacheNotice>> PendingAsync(string store, string customer, int count = 100)
        => NoticesAsync(store, customer, count, true);

    // Each live socket has its own cursor; a push receipt must not consume another device's changes.
    public Task<IReadOnlyList<ClientCacheNotice>> ChangedAsync(string store, string customer)
        => NoticesAsync(store, customer, MaximumCorrelations, false);

    private async Task<IReadOnlyList<ClientCacheNotice>> NoticesAsync(string store, string customer, int count, bool unsentOnly)
    {
        if (count < 1 || count > (unsentOnly ? 100 : MaximumCorrelations)) throw new ArgumentOutOfRangeException(nameof(count));
        var p = Prefix(store); var owner = Owner(customer); var db = _redis.GetDatabase(); var state = await ReadState(store).ConfigureAwait(false);
        var ids = await db.SortedSetRangeByRankAsync(p + "owner:" + owner, 0, MaximumCorrelations - 1, Order.Descending).ConfigureAwait(false);
        var result = new List<ClientCacheNotice>();
        if (ids.Length == 0) await db.SortedSetRemoveAsync(p + "owners", customer).ConfigureAwait(false);
        foreach (var item in ids)
        {
            if (!Guid.TryParseExact(item.ToString(), "N", out var id)) continue;
            var record = await db.HashGetAllAsync(p + "correlation:" + owner + ":" + id.ToString("N")).ConfigureAwait(false);
            if (record.Length == 0) { await db.SortedSetRemoveAsync(p + "owner:" + owner, item).ConfigureAwait(false); continue; }
            var token = DirtyToken(state, record, customer);
            var sent = record.FirstOrDefault(x => x.Name == "$sent").Value;
            if (token != null && token != "missing" && (!unsentOnly || token != sent.ToString())) result.Add(new(id.ToString("D"), token));
            if (result.Count == count) break;
        }
        return result;
    }

    public async Task AcknowledgeAsync(string store, string customer, IReadOnlyList<ClientCacheNotice> notices)
    {
        var p = Prefix(store) + "correlation:" + Owner(customer) + ":"; var db = _redis.GetDatabase();
        foreach (var notice in notices)
        {
            if (!Guid.TryParse(notice.CorrelationId, out var id) || notice.Revision.Length > 100) throw new ArgumentException("Invalid owned cache receipt.");
            await db.ScriptEvaluateAsync("if redis.call('HGET',KEYS[1],'$owner')==ARGV[1] then return redis.call('HSET',KEYS[1],'$sent',ARGV[2]) end return 0",
                [p + id.ToString("N")], [customer, notice.Revision]).ConfigureAwait(false);
        }
    }

    public async Task<IReadOnlyList<string>> NextOwnersAsync(string store, int count = 100)
    {
        if (count is < 1 or > 100) throw new ArgumentOutOfRangeException(nameof(count));
        var key = Prefix(store) + "owners"; var db = _redis.GetDatabase();
        var script = """
            local owners=redis.call('ZRANGE',KEYS[1],0,tonumber(ARGV[1])-1)
            local t=redis.call('TIME');local now=tonumber(t[1])*1000+math.floor(tonumber(t[2])/1000)
            for _,owner in ipairs(owners) do redis.call('ZADD',KEYS[1],now,owner) end
            return owners
            """;
        var rows = (RedisResult[])await db.ScriptEvaluateAsync(script, [key], [count]).ConfigureAwait(false);
        return rows.Select(x => (string)x).ToArray();
    }
}
