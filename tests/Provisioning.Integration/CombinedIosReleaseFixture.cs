using System.Net;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Npgsql;
using Platform.Google;
using Platform.Provisioning;
using Platform.Provisioning.Adapters;
using Platform.Security;

internal static class CombinedIosReleaseFixture
{
    private static void Check(bool value, string message)
    { if (!value) throw new Exception("FAILED: " + message); Console.WriteLine("PASS: " + message); }
    private static async Task Reject<T>(Func<Task> action, string message) where T : Exception
    { try { await action(); } catch (T) { Check(true, message); return; } throw new Exception("FAILED: " + message); }
    private sealed class Tokens : IGoogleAccessTokenSource
    { public Task<string> GetAsync(string scope, CancellationToken ct) => Task.FromResult("synthetic-integration-access"); }
    private sealed class GoogleServer(GoogleCloudOptions options) : HttpMessageHandler
    {
        public readonly Dictionary<string, TenantFirebaseConfiguration> Tenants = new();
        public int Writes;
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct)
        {
            if (request.Method != HttpMethod.Get) { Writes++; throw new InvalidOperationException("Unexpected fixture provider write."); }
            var path = request.RequestUri!.AbsolutePath; object value;
            if (request.RequestUri.Host == "cloudresourcemanager.googleapis.com")
            {
                var tenant = Tenants[path.Split('/').Last()];
                value = new { name = "projects/" + tenant.ProjectNumber, parent = options.Parent, state = "ACTIVE",
                    labels = new Dictionary<string, string> { ["platform-tenant"] = tenant.TenantId, ["platform-deployment"] = options.DeploymentId } };
            }
            else if (request.RequestUri.Host == "firebaseappdistribution.googleapis.com" && path.EndsWith("/releases/fixture", StringComparison.Ordinal))
                value = new { name = path["/v1/".Length..], buildVersion = "7" };
            else throw new InvalidOperationException("Unexpected fixture provider read.");
            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK) { Content = JsonContent.Create(value) });
        }
    }
    private sealed class AndroidStep(GoogleServer server) : IProvisioningStep
    {
        public readonly Dictionary<string, int> Calls = new();
        public string Name => "mobile-android-release";
        public Task<ProvisioningStepResult> ExecuteAsync(TenantProvisioningRequest request, IReadOnlyDictionary<string, ProvisioningStepResult> completed, CancellationToken ct)
        {
            Calls[request.TenantId] = Calls.GetValueOrDefault(request.TenantId) + 1;
            var firebase = server.Tenants.Values.Single(x => x.TenantId == request.TenantId);
            return Task.FromResult(new ProvisioningStepResult("AndroidAppDistribution", new Dictionary<string, string> {
                ["buildNumber"] = "7", ["androidAppId"] = firebase.AndroidAppId, ["androidApplicationId"] = firebase.AndroidPackageName, ["sourceHash"] = new string('a', 64), ["sha256"] = new string('b', 64),
                ["signingCertificateSha256"] = new string('c', 64), ["release"] = $"projects/{firebase.ProjectNumber}/apps/{firebase.AndroidAppId}/releases/fixture" }));
        }
    }
    private sealed class MacExecutor : IIosReleaseExecutor
    { public Task<IosReleaseReceipt> ExecuteAsync(IosReleasePlan plan, CancellationToken ct) => Task.FromResult(Receipt(plan)); }
    private static IosReleaseReceipt Receipt(IosReleasePlan plan)
    {
        string Profile(string kind) => new Guid(SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(plan.TenantId + ":" + kind))[..16]).ToString("D");
        return new(new string('f', 64), plan.SourceHash, plan.SigningCertificateSha256, plan.FirebaseSdkSha256, plan.BuildNumber,
            Profile("app"), Profile("extension"), $"projects/{plan.ProjectNumber}/apps/{plan.IosAppId}/releases/fixture", true);
    }
    internal static async Task RunAsync(string connection, string master)
    {
        await using var roles = await ProductionQueueRolesFixture.CreateAsync(connection);
        await using var parents = new PostgresProvisioningQueue(roles.WorkerConnection);
        await using var saas = new PostgresProvisioningQueue(roles.SaasConnection);
        await using var saasIos = new PostgresIosReleaseQueue(roles.SaasConnection);
        await using var queue = new PostgresIosReleaseQueue(roles.WorkerConnection);
        using var secrets = new PostgresSecretStore(roles.WorkerConnection, new PortableEncryptionService(master), false);
        await secrets.InitializeAsync();
        ITenantSecrets tenantSecrets = secrets;
        var google = new GoogleCloudOptions { AllowCloudWrites = true, DeploymentId = "ios-bridge-fixture", ProjectIdPrefix = "bridge", Parent = "folders/123456",
            SenderServiceAccount = "sender-account@sender-project.iam.gserviceaccount.com" };
        var deployment = new PortableOnboardingOptions { DeploymentId = google.DeploymentId, StoreBaseUrl = "https://shops.example.test", AdminBaseUrl = "https://manage.example.test" };
        var binding = new IosReleaseBindingOptions { DevelopmentTeam = "ABCDE12345", SigningCertificateSha256 = new string('a', 64), ExpectedSourceHash = new string('b', 64), BuildNumber = 7 };
        using var server = new GoogleServer(google); using var http = new HttpClient(server, false);
        var coordinator = new IosReleaseCoordinator(binding, deployment, google, tenantSecrets, queue, new FirebaseAppDistribution(new GoogleRestClient(http, new Tokens()), google));
        var android = new AndroidStep(server);
        using var services = new ServiceCollection().AddSingleton<IProvisioningGuard>(new IosReleaseGuard(coordinator))
            .AddSingleton<IProvisioningStep>(new IosReleaseEnqueueStep(coordinator)).AddSingleton<IProvisioningStep>(android)
            .AddSingleton<IProvisioningStep>(new IosReleaseStep(coordinator)).BuildServiceProvider();
        using var worker = new ProvisioningWorker(parents, services.GetRequiredService<IServiceScopeFactory>(), new() { MaxAttempts = 1 }, NullLogger<ProvisioningWorker>.Instance);
        var apnsGoogle = new GoogleCloudOptions { AllowCloudWrites = true, DeploymentId = google.DeploymentId, ProjectIdPrefix = google.ProjectIdPrefix,
            Parent = google.Parent, SenderServiceAccount = google.SenderServiceAccount, IosPushTransport = "Apns", IosDevelopmentTeam = binding.DevelopmentTeam };
        var apnsCoordinator = new IosReleaseCoordinator(binding, deployment, apnsGoogle, tenantSecrets, queue,
            new FirebaseAppDistribution(new GoogleRestClient(http, new Tokens()), apnsGoogle));
        using var apnsServices = new ServiceCollection().AddSingleton<IProvisioningGuard>(new IosReleaseGuard(apnsCoordinator))
            .AddSingleton<IProvisioningStep>(new IosReleaseEnqueueStep(apnsCoordinator)).AddSingleton<IProvisioningStep>(android)
            .AddSingleton<IProvisioningStep>(new IosReleaseStep(apnsCoordinator)).BuildServiceProvider();
        using var apnsWorker = new ProvisioningWorker(parents, apnsServices.GetRequiredService<IServiceScopeFactory>(), new() { MaxAttempts = 1 }, NullLogger<ProvisioningWorker>.Instance);
        var identity = new IosWorkerIdentity(deployment.DeploymentId, binding.DevelopmentTeam, binding.SigningCertificateSha256, binding.ExpectedSourceHash);
        using var mac = new IosReleaseWorker(queue, new MacExecutor(), new() { Identity = identity }, NullLogger<IosReleaseWorker>.Instance);
        async Task<IosReleaseJob> BuildOnMac(string tenant)
        {
            var lease = (await queue.ClaimAsync(identity, TimeSpan.FromMinutes(2)))!;
            Check(lease.Job.Plan.TenantId == tenant, "The Mac lane claims only the scheduled combined tenant");
            await mac.RunAsync(lease, default); return (await queue.GetAsync(tenant))!;
        }
        async Task MakeAvailable(string tenant)
        {
            await using var db = new NpgsqlConnection(connection); await db.OpenAsync();
            await using var update = new NpgsqlCommand("UPDATE platform_provisioning.jobs SET available_at=now() WHERE tenant_id=$1", db);
            update.Parameters.AddWithValue(tenant); await update.ExecuteNonQueryAsync();
        }
        async Task<ProvisioningLease> Claim(string tenant)
        {
            await MakeAvailable(tenant); var lease = (await parents.ClaimAsync(TimeSpan.FromMinutes(2)))!;
            Check(lease.Job.Request.TenantId == tenant, "The parent worker claims only the intended combined onboarding job"); return lease;
        }
        TenantProvisioningRequest Request() => new(Guid.NewGuid().ToString("N"), "combined-" + Guid.NewGuid().ToString("N")[..10], "Synthetic Combined Store",
            "owner@example.test", "Fixture", "Owner", "Street", "5551234567", "store@example.test", DeploymentId: deployment.DeploymentId, MobileReleaseProfile: "AndroidIosAppDistribution");
        async Task<TenantProvisioningRequest> Schedule(bool apns = false)
        {
            var request = Request(); var tenant = request.TenantId; var package = "com.example.tenant" + tenant;
            var number = (123456789 + server.Tenants.Count).ToString(System.Globalization.CultureInfo.InvariantCulture); var project = google.ProjectId(tenant);
            var androidApp = "1:" + number + ":android:" + tenant[..16]; var iosApp = "1:" + number + ":ios:" + tenant[..16];
            var androidJson = JsonSerializer.Serialize(new { project_info = new { project_id = project, project_number = number },
                client = new[] { new { client_info = new { mobilesdk_app_id = androidApp, android_client_info = new { package_name = package } } } } });
            var plist = $"<plist><dict><key>PROJECT_ID</key><string>{project}</string><key>GCM_SENDER_ID</key><string>{number}</string><key>GOOGLE_APP_ID</key><string>{iosApp}</string><key>BUNDLE_ID</key><string>{package}</string><key>API_KEY</key><string>synthetic-public-key</string></dict></plist>";
            var firebase = new TenantFirebaseConfiguration(tenant, project, number, google.SenderServiceAccount, androidApp, iosApp, package, package, androidJson, plist, google.DistributionGroupAlias);
            if (apns) firebase = firebase with { IosPushTransport = "Apns", IosDevelopmentTeam = binding.DevelopmentTeam };
            server.Tenants[project] = firebase;
            await tenantSecrets.ProvisionAsync(tenant, request.Slug);
            await tenantSecrets.SetAsync(tenant, TenantFirebaseConfiguration.SecretName, JsonSerializer.Serialize(firebase));
            await parents.EnqueueAsync(request); var lease = await Claim(tenant);
            await parents.CheckpointAsync(lease, "publication", new("Portable", new Dictionary<string, string> { ["readiness"] = "Verified", ["storeUrl"] = deployment.StoreUrl(request.Slug) }));
            await parents.CheckpointAsync(lease, "google-firebase", new("Google", new Dictionary<string, string> { ["projectId"] = project, ["projectNumber"] = number, ["androidAppId"] = androidApp, ["iosAppId"] = iosApp, ["notificationProvider"] = apns ? "FcmApns" : "Fcm" }));
            await (apns ? apnsWorker : worker).RunAsync(lease with { Job = (await parents.GetAsync(tenant))! }, default);
            var status = (await parents.GetAsync(tenant))!;
            if (status.State != "Pending" || status.ErrorCode != "mobile-ios-release:WaitingForMac")
            {
                // Fixture diagnostics contain safe state/type codes only, never a database or provider response body.
                throw new Exception("Combined parent state: " + status.State + ", error: " + status.ErrorCode);
            }
            Check(status.Attempts == 0,
                "The real parent coordinator schedules iOS then defers without reporting completion or spending a failed attempt");
            return request;
        }
        // Prerequisite publication/Google and native executors above are synthetic; all queue, guards and parent worker code below are real.
        var first = await Schedule(); var firstJob = (await parents.GetAsync(first.TenantId))!;
        Check(firstJob.Steps.ContainsKey("mobile-ios-enqueue") && firstJob.Steps.ContainsKey("mobile-android-release") && !firstJob.Steps.ContainsKey("mobile-ios-release"),
            "iOS scheduling is persisted before Android and the missing iOS result stays visibly incomplete");
        var beforeMac = await Claim(first.TenantId);
        await Reject<PostgresException>(() => parents.CompleteAsync(beforeMac), "The database refuses combined completion while the Mac release is still pending");
        await worker.RunAsync(beforeMac, default);
        var built = await BuildOnMac(first.TenantId);
        Check(built.State == "Succeeded" && built.Receipt != null, "The independent Mac lane persists its matching synthetic native receipt");
        Check((await saasIos.GetAsync(first.TenantId))?.Receipt == built.Receipt, "The restricted SaaS role can read its iOS progress without Mac credentials");
        await using (var actor = new NpgsqlConnection(roles.SaasConnection))
        {
            await actor.OpenAsync(); await using var overwrite = new NpgsqlCommand("UPDATE platform_provisioning.ios_release_jobs SET receipt=receipt WHERE tenant_id=$1", actor);
            overwrite.Parameters.AddWithValue(first.TenantId);
            try { await overwrite.ExecuteNonQueryAsync(); throw new Exception("SaaS unexpectedly acquired native receipt write permission."); }
            catch (PostgresException error) when (error.SqlState == PostgresErrorCodes.InsufficientPrivilege)
            { Check(true, "The restricted SaaS role cannot overwrite a native iOS receipt"); }
        }
        var ready = await Claim(first.TenantId);
        var expected = await coordinator.CompleteAsync(first, ready.Job.Steps, default);
        var wrong = expected with { Resources = new Dictionary<string, string>(expected.Resources) { ["sha256"] = new string('e', 64) } };
        await parents.CheckpointAsync(ready, "mobile-ios-release", wrong);
        await Reject<PostgresException>(() => parents.CompleteAsync(ready), "A real iOS completion cannot be paired with a substituted parent IPA digest");
        await worker.RunAsync(ready, default);
        Check((await parents.GetAsync(first.TenantId)) is { State: "Succeeded" } && android.Calls[first.TenantId] == 1,
            "The resumed real coordinator verifies the saved iOS release and completes without repeating Android");

        await BrandingReleaseFixture.RunAsync(connection,roles.SaasConnection,roles.WorkerConnection,(await parents.GetAsync(first.TenantId))!,built.Plan);

        var failed = await Schedule(); var failedChild = (await queue.ClaimAsync(identity, TimeSpan.FromMinutes(2)))!;
        await queue.FailAsync(failedChild, "native:SyntheticFailure", 1);
        await worker.RunAsync(await Claim(failed.TenantId), default);
        Check((await parents.GetAsync(failed.TenantId)) is { State: "Failed", ErrorCode: "mobile-ios-release:IosReleaseFailedException" },
            "A failed Mac release leaves the combined parent failed with a safe public error code");
        await using (var db = new NpgsqlConnection(connection))
        {
            await db.OpenAsync();
            await using (var reject = new NpgsqlCommand("""
                CREATE FUNCTION platform_provisioning.fixture_reject_ios_retry() RETURNS trigger LANGUAGE plpgsql AS $$
                BEGIN RAISE EXCEPTION 'Synthetic retry failure'; END; $$;
                CREATE TRIGGER fixture_reject_ios_retry BEFORE UPDATE ON platform_provisioning.ios_release_jobs
                    FOR EACH ROW WHEN (OLD.state='Failed' AND NEW.state='Pending') EXECUTE FUNCTION platform_provisioning.fixture_reject_ios_retry();
                """, db)) await reject.ExecuteNonQueryAsync();
            try
            {
                await Reject<PostgresException>(() => saas.RetryAsync(failed.TenantId), "A failed child reset rolls back the parent retry in the same transaction");
                Check((await parents.GetAsync(failed.TenantId))?.State == "Failed" && (await queue.GetAsync(failed.TenantId))?.State == "Failed",
                    "Retry failure preserves both original failed states");
            }
            finally
            {
                await using var drop = new NpgsqlCommand("DROP TRIGGER fixture_reject_ios_retry ON platform_provisioning.ios_release_jobs; DROP FUNCTION platform_provisioning.fixture_reject_ios_retry()", db);
                await drop.ExecuteNonQueryAsync();
            }
        }
        var failedPlan = (await queue.GetAsync(failed.TenantId))!.Plan;
        Check(await saas.RetryAsync(failed.TenantId) && (await queue.GetAsync(failed.TenantId)) is { State: "Pending", Attempts: 0 },
            "An owned parent retry reopens only the failed iOS lane and resets its attempt accounting");
        Check((await queue.GetAsync(failed.TenantId))?.Plan == failedPlan, "Retry preserves the original iOS source, version, certificate and Firebase SDK binding");
        await BuildOnMac(failed.TenantId); await worker.RunAsync(await Claim(failed.TenantId), default);
        Check((await parents.GetAsync(failed.TenantId))?.State == "Succeeded" && android.Calls[failed.TenantId] == 1,
            "The combined retry resumes the same iOS plan without signing or distributing Android again");

        var preserved = await Schedule(); var original = await BuildOnMac(preserved.TenantId);
        await parents.FailAsync(await Claim(preserved.TenantId), "other:SyntheticFailure", 1);
        Check(await saas.RetryAsync(preserved.TenantId), "A parent can retry another failure after iOS completed");
        var untouched = (await queue.GetAsync(preserved.TenantId))!;
        Check(untouched.Receipt == original.Receipt && untouched.UpdatedAt == original.UpdatedAt && untouched.Attempts == original.Attempts,
            "Retry never resets or rewrites a completed iOS artifact receipt");
        await worker.RunAsync(await Claim(preserved.TenantId), default);

        await using (var db = new NpgsqlConnection(connection))
        {
            await db.OpenAsync();
            await using (var disable = new NpgsqlCommand("ALTER TABLE platform_provisioning.jobs DISABLE TRIGGER enforce_ios_release_v1", db)) await disable.ExecuteNonQueryAsync();
            var blocked = Request();
            try
            {
                await Reject<InvalidOperationException>(() => parents.EnqueueAsync(blocked), "An older or disabled iOS protocol refuses combined enrollment before creating a job");
                Check(await parents.GetAsync(blocked.TenantId) == null, "Missing protocol leaves no half-queued combined request");
            }
            finally
            {
                await using var enable = new NpgsqlCommand("ALTER TABLE platform_provisioning.jobs ENABLE TRIGGER enforce_ios_release_v1", db); await enable.ExecuteNonQueryAsync();
            }
        }
        var direct = await Schedule(apns: true);
        var directPlan = (await queue.GetAsync(direct.TenantId))!.Plan;
        Check(directPlan.PushTransport == "Apns", "The real coordinator persists the APNs transport in the immutable Mac plan");
        await BuildOnMac(direct.TenantId);
        var directReady = await Claim(direct.TenantId);
        var directResult = await apnsCoordinator.CompleteAsync(direct, directReady.Job.Steps, default);
        var queued = directReady.Job.Steps["mobile-ios-enqueue"];
        var cloud = directReady.Job.Steps["google-firebase"];
        var missing = new Dictionary<string, string>(queued.Resources); missing.Remove("iosPushTransport");
        await parents.CheckpointAsync(directReady, "mobile-ios-enqueue", queued with { Resources = missing });
        await parents.CheckpointAsync(directReady, "mobile-ios-release", directResult);
        await Reject<PostgresException>(() => parents.CompleteAsync(directReady), "The database refuses an APNs completion missing the original queue transport evidence");
        await parents.CheckpointAsync(directReady, "mobile-ios-enqueue", queued);
        await parents.CheckpointAsync(directReady, "mobile-ios-release", directResult with { Resources = new Dictionary<string, string>(directResult.Resources) { ["iosPushTransport"] = "Fcm" } });
        await Reject<PostgresException>(() => parents.CompleteAsync(directReady), "The database refuses substituted FCM evidence for a completed APNs plan");
        await parents.CheckpointAsync(directReady, "mobile-ios-release", directResult);
        await parents.CheckpointAsync(directReady, "google-firebase", cloud with { Resources = new Dictionary<string, string>(cloud.Resources) { ["notificationProvider"] = "Fcm" } });
        await Reject<PostgresException>(() => parents.CompleteAsync(directReady), "The database requires the matching composite notification provider for APNs publication");
        var mismatchedSteps = (await parents.GetAsync(direct.TenantId))!.Steps;
        await Reject<InvalidOperationException>(() => apnsCoordinator.EnqueueAsync(direct, mismatchedSteps, default),
            "The coordinator refuses changed notification routing before another Mac job can be queued");
        await parents.CheckpointAsync(directReady, "google-firebase", cloud);
        await apnsWorker.RunAsync(directReady with { Job = (await parents.GetAsync(direct.TenantId))! }, default);
        Check((await parents.GetAsync(direct.TenantId))?.State == "Succeeded" && android.Calls[direct.TenantId] == 1,
            "Matching APNs evidence completes the real combined tenant without repeating Android");
        Check(server.Writes == 0, "The real queue/coordinator fixture performs no Google, Apple or distribution writes");
    }
}
