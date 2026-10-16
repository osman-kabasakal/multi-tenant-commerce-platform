using System.Net;
using System.Text;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using static Platform.Google.GoogleRestClient;

namespace Platform.Google;

public sealed class GoogleTenantProvisioner(GoogleRestClient api, GoogleCloudOptions options)
{
    public async Task<TenantFirebaseConfiguration> EnsureAsync(GoogleTenantSpec spec, CancellationToken ct)
    {
        options.Validate();
        if (string.IsNullOrWhiteSpace(spec.DisplayName) || spec.DisplayName.Length > 200 ||
            !System.Net.Mail.MailAddress.TryCreate(spec.OwnerEmail, out var owner) || owner.Address != spec.OwnerEmail ||
            !Regex.IsMatch(spec.AndroidPackageName, "^[a-zA-Z][a-zA-Z0-9_]*(\\.[a-zA-Z][a-zA-Z0-9_]*)+$") ||
            spec.IosBundleId.Length > 220 || !Regex.IsMatch(spec.IosBundleId, "^[a-zA-Z][a-zA-Z0-9-]*(\\.[a-zA-Z][a-zA-Z0-9-]*)+$"))
            throw new ArgumentException("Invalid Google tenant specification.");
        var owners = await OrganizationAdminOwnersAsync(ct);
        var id = options.ProjectId(spec.TenantId);
        var project = await EnsureProjectAsync(id, spec, ct);
        var number = Text(project, "name")["projects/".Length..];
        await EnsureBillingAsync(id, ct);
        var enable = await api.SendAsync(GoogleApi.ServiceUsage, HttpMethod.Post, $"v1/projects/{number}/services:batchEnable",
            new { serviceIds = new[] { "firebase.googleapis.com", "firebaseinstallations.googleapis.com", "fcm.googleapis.com", "firebasecrashlytics.googleapis.com", "firebaseappdistribution.googleapis.com" } }, ct);
        await api.WaitAsync(GoogleApi.ServiceUsage, "v1", enable!, options, ct);
        var firebase = await api.SendAsync(GoogleApi.Firebase, HttpMethod.Get, $"v1beta1/projects/{id}", null, ct, true);
        if (firebase == null)
        {
            var operation = await api.SendAsync(GoogleApi.Firebase, HttpMethod.Post, $"v1beta1/projects/{id}:addFirebase", new { }, ct);
            await api.WaitAsync(GoogleApi.Firebase, "v1beta1", operation!, options, ct);
            firebase = await api.SendAsync(GoogleApi.Firebase, HttpMethod.Get, $"v1beta1/projects/{id}", null, ct);
        }
        if (Text(firebase!, "projectId") != id || Text(firebase!, "projectNumber") != number)
            throw new InvalidOperationException("Firebase project identity does not match the owned Google project.");
        var android = await EnsureAppAsync(id, number, "androidApps", "packageName", spec.AndroidPackageName, spec.DisplayName, ct);
        var ios = await EnsureAppAsync(id, number, "iosApps", "bundleId", spec.IosBundleId, spec.DisplayName, ct);
        await GrantProjectAccessAsync(number, owners, ct);
        await EnsureTestersAsync(number, spec.OwnerEmail, ct);
        var androidConfig = await ConfigAsync(id, "androidApps", android, ct);
        var iosConfig = await ConfigAsync(id, "iosApps", ios, ct);
        var result = new TenantFirebaseConfiguration(spec.TenantId, id, number, options.SenderServiceAccount,
            android, ios, spec.AndroidPackageName, spec.IosBundleId, androidConfig, iosConfig, options.DistributionGroupAlias)
            { IosPushTransport = options.IosPushTransport, IosDevelopmentTeam = options.IosDevelopmentTeam };
        FirebaseConfigValidator.Validate(result);
        return result;
    }

    private async Task<JsonObject> EnsureProjectAsync(string id, GoogleTenantSpec spec, CancellationToken ct)
    {
        var path = "v3/projects/" + id;
        JsonObject? project = null;
        try { project = await api.SendAsync(GoogleApi.ResourceManager, HttpMethod.Get, path, null, ct, true); }
        catch (GoogleApiException error) when (error.StatusCode == HttpStatusCode.Forbidden)
        {
            // Resource Manager also hides nonexistent projects with 403. An explicit create
            // can reconcile that ambiguity; conflicts still require a readable, owned project.
        }
        if (project == null)
        {
            try
            {
                var operation = await api.SendAsync(GoogleApi.ResourceManager, HttpMethod.Post, "v3/projects", new
                {
                    projectId = id, displayName = spec.DisplayName[..Math.Min(spec.DisplayName.Length, 30)], parent = options.Parent,
                    labels = new Dictionary<string, string> { ["platform-tenant"] = spec.TenantId, ["platform-deployment"] = options.DeploymentId }
                }, ct);
                await api.WaitAsync(GoogleApi.ResourceManager, "v3", operation!, options, ct);
            }
            catch (GoogleApiException e) when (e.StatusCode == HttpStatusCode.Conflict) { /* Reconcile after another worker's create. */ }
            project = await api.SendAsync(GoogleApi.ResourceManager, HttpMethod.Get, path, null, ct);
        }
        if (project == null || Text(project, "projectId") != id || Text(project, "parent") != options.Parent ||
            project["labels"]?["platform-tenant"]?.GetValue<string>() != spec.TenantId ||
            project["labels"]?["platform-deployment"]?.GetValue<string>() != options.DeploymentId ||
            !Regex.IsMatch(Text(project, "name"), "^projects/[1-9][0-9]*$") || Text(project, "state") != "ACTIVE")
            throw new InvalidOperationException("Google project is not active or has conflicting tenant ownership.");
        return project;
    }

    private async Task EnsureBillingAsync(string id, CancellationToken ct)
    {
        if (string.IsNullOrEmpty(options.BillingAccount)) return;
        var path = $"v1/projects/{id}/billingInfo";
        var info = (await api.SendAsync(GoogleApi.Billing, HttpMethod.Get, path, null, ct))!;
        var account = info["billingAccountName"]?.GetValue<string>();
        if (!string.IsNullOrEmpty(account) && account != options.BillingAccount)
            throw new InvalidOperationException("Owned Google project is linked to a different billing account.");
        if (account == options.BillingAccount && info["billingEnabled"]?.GetValue<bool>() == true) return;
        await api.SendAsync(GoogleApi.Billing, HttpMethod.Put, path, new { billingAccountName = options.BillingAccount }, ct);
    }

    private async Task<string> EnsureAppAsync(string id, string number, string kind, string identifier, string package, string displayName, CancellationToken ct)
    {
        var path = $"v1beta1/projects/{id}/{kind}";
        var matches = await FindAppsAsync(path, identifier, package, ct);
        if (matches.Count == 0)
        {
            try
            {
                var body = new JsonObject { [identifier] = package, ["displayName"] = displayName[..Math.Min(displayName.Length, 30)] };
                var op = await api.SendAsync(GoogleApi.Firebase, HttpMethod.Post, path, body, ct);
                await api.WaitAsync(GoogleApi.Firebase, "v1beta1", op!, options, ct);
            }
            catch (GoogleApiException e) when (e.StatusCode == HttpStatusCode.Conflict) { }
            matches = await FindAppsAsync(path, identifier, package, ct);
        }
        if (matches.Count != 1) throw new InvalidOperationException("Firebase app identity is missing or ambiguous.");
        var app = matches[0];
        var appId = Text(app, "appId");
        var platform = kind == "androidApps" ? "android" : "ios";
        if (app["state"]?.GetValue<string>() is not (null or "ACTIVE") ||
            !Regex.IsMatch(appId, "^1:" + number + ":" + platform + ":[a-zA-Z0-9]+$") ||
            (Text(app, "name") != $"projects/{id}/{kind}/{appId}" && Text(app, "name") != $"projects/{number}/{kind}/{appId}"))
            throw new InvalidOperationException("Firebase app does not belong to the owned project.");
        return appId;
    }

    private async Task<List<JsonObject>> FindAppsAsync(string path, string identifier, string package, CancellationToken ct)
    {
        List<JsonObject> matches = [];
        HashSet<string> pages = [];
        string? token = null;
        do
        {
            var page = (await api.SendAsync(GoogleApi.Firebase, HttpMethod.Get,
                path + "?pageSize=100" + (token == null ? "" : "&pageToken=" + Segment(token)), null, ct))!;
            if (page["apps"] is JsonArray apps)
                matches.AddRange(apps.OfType<JsonObject>().Where(app => app[identifier]?.GetValue<string>() == package));
            token = page["nextPageToken"]?.GetValue<string>();
            if (!string.IsNullOrEmpty(token) && (!pages.Add(token) || pages.Count > 100))
                throw new InvalidOperationException("Firebase app pagination did not terminate.");
        } while (!string.IsNullOrEmpty(token));
        return matches;
    }

    private async Task<string> ConfigAsync(string id, string kind, string app, CancellationToken ct)
    {
        var config = (await api.SendAsync(GoogleApi.Firebase, HttpMethod.Get, $"v1beta1/projects/{id}/{kind}/{Segment(app)}/config", null, ct))!;
        var bytes = Convert.FromBase64String(Text(config, "configFileContents"));
        if (bytes.Length > 2 * 1024 * 1024) throw new InvalidOperationException("Firebase client configuration is too large.");
        return new UTF8Encoding(false, true).GetString(bytes);
    }

    private async Task<string[]> OrganizationAdminOwnersAsync(CancellationToken ct)
    {
        if (!options.GrantOrganizationAdminUsersProjectOwner) return [];
        var parent = options.Parent;
        HashSet<string> folders = [];
        while (parent.StartsWith("folders/", StringComparison.Ordinal))
        {
            if (!Regex.IsMatch(parent, @"\Afolders/[1-9][0-9]*\z") || !folders.Add(parent) || folders.Count > 10)
                throw new InvalidOperationException("Cannot resolve the configured folder's organization safely.");
            var folder = (await api.SendAsync(GoogleApi.ResourceManager, HttpMethod.Get, "v3/" + parent, null, ct))!;
            if (Text(folder, "name") != parent || Text(folder, "state") != "ACTIVE")
                throw new InvalidOperationException("The configured folder ancestry is not active or has conflicting identity.");
            parent = Text(folder, "parent");
        }
        if (!Regex.IsMatch(parent, @"\Aorganizations/[1-9][0-9]*\z"))
            throw new InvalidOperationException("Organization administrator owners require a verified organization parent.");
        var policy = (await api.SendAsync(GoogleApi.ResourceManager, HttpMethod.Post, "v3/" + parent + ":getIamPolicy",
            new { options = new { requestedPolicyVersion = 3 } }, ct))!;
        if (policy["bindings"] is not JsonArray bindings)
            throw new InvalidOperationException("The organization IAM policy is missing its bindings.");
        HashSet<string> owners = new(StringComparer.Ordinal);
        foreach (var binding in bindings.OfType<JsonObject>().Where(b => b["role"]?.GetValue<string>() == "roles/resourcemanager.organizationAdmin"))
        {
            if (binding["members"] is not JsonArray members)
                throw new InvalidOperationException("The organization administrator binding is missing its members.");
            foreach (var node in members)
            {
                var member = node?.GetValue<string>() ?? throw new InvalidOperationException("Invalid organization administrator member.");
                if (member.StartsWith("serviceAccount:", StringComparison.Ordinal)) continue;
                // Groups and conditional bindings cannot be expanded into unconditional human ownership.
                if (binding["condition"] != null || !member.StartsWith("user:", StringComparison.Ordinal) ||
                    member.Any(char.IsWhiteSpace) || !System.Net.Mail.MailAddress.TryCreate(member[5..], out var address) ||
                    address.Address != member[5..] || address.Host.EndsWith(".gserviceaccount.com", StringComparison.OrdinalIgnoreCase))
                    throw new InvalidOperationException("Automatic project owners require direct, unconditional organization administrator user accounts.");
                owners.Add(member);
            }
        }
        if (owners.Count is 0 or > 100)
            throw new InvalidOperationException("Automatic project ownership requires between one and 100 organization administrator users.");
        return owners.Order(StringComparer.Ordinal).ToArray();
    }

    private async Task GrantProjectAccessAsync(string number, string[] owners, CancellationToken ct)
    {
        var basePath = $"v3/projects/{number}";
        var policy = (await api.SendAsync(GoogleApi.ResourceManager, HttpMethod.Post, basePath + ":getIamPolicy",
            new { options = new { requestedPolicyVersion = 3 } }, ct))!;
        if (string.IsNullOrEmpty(policy["etag"]?.GetValue<string>()))
            throw new InvalidOperationException("Google IAM policy is missing its concurrency token.");
        var bindings = policy["bindings"] as JsonArray;
        if (bindings == null) { bindings = []; policy["bindings"] = bindings; }
        var grants = owners.Select(member => (Role: "roles/owner", Member: member))
            .Prepend((Role: "roles/firebasecloudmessaging.admin", Member: "serviceAccount:" + options.SenderServiceAccount));
        var changed = false;
        foreach (var (role, member) in grants)
        {
            var binding = bindings.OfType<JsonObject>().FirstOrDefault(b => b["role"]?.GetValue<string>() == role && b["condition"] == null);
            if (binding == null) { binding = new JsonObject { ["role"] = role, ["members"] = new JsonArray() }; bindings.Add(binding); }
            var members = binding["members"] as JsonArray ?? throw new InvalidOperationException("Invalid Google IAM binding.");
            if (members.Any(m => m?.GetValue<string>() == member)) continue;
            members.Add(member);
            changed = true;
        }
        if (changed) await api.SendAsync(GoogleApi.ResourceManager, HttpMethod.Post, basePath + ":setIamPolicy", new { policy }, ct);
    }

    private async Task EnsureTestersAsync(string number, string owner, CancellationToken ct)
    {
        var group = $"projects/{number}/groups/{options.DistributionGroupAlias}";
        var found = await api.SendAsync(GoogleApi.Distribution, HttpMethod.Get, "v1/" + group, null, ct, true);
        if (found == null)
        {
            try
            {
                found = await api.SendAsync(GoogleApi.Distribution, HttpMethod.Post,
                    $"v1/projects/{number}/groups?groupId={options.DistributionGroupAlias}", new { displayName = "Tenant testers" }, ct);
            }
            catch (GoogleApiException e) when (e.StatusCode == HttpStatusCode.Conflict)
            { found = await api.SendAsync(GoogleApi.Distribution, HttpMethod.Get, "v1/" + group, null, ct); }
        }
        if (found == null || Text(found, "name") != group) throw new InvalidOperationException("App Distribution group ownership mismatch.");
        var emails = options.TesterEmails.Concat(options.IncludeOwnerAsTester ? [owner] : Array.Empty<string>()).Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
        if (emails.Length != 0)
            await api.SendAsync(GoogleApi.Distribution, HttpMethod.Post, "v1/" + group + ":batchJoin", new { emails, createMissingTesters = true }, ct);
    }
}
