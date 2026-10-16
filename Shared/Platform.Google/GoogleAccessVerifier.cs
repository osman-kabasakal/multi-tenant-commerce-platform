using System.Text.Json.Nodes;
using System.Text.RegularExpressions;

namespace Platform.Google;

public sealed record GoogleAccessCheck(string Name, string Status, int? HttpStatus, string[] Details);
public sealed record GoogleAccessReport(string ProjectId, string? ProjectNumber, string? CredentialProjectParent,
    string? TargetParent, IReadOnlyList<GoogleAccessCheck> Checks);

/// <summary>Non-mutating diagnostics. Successful permission tests do not prove quotas, terms or effective future-project access.</summary>
public sealed class GoogleAccessVerifier(GoogleRestClient api)
{
    private static readonly string[] ProjectPermissions =
    [
        "resourcemanager.projects.get", "resourcemanager.projects.getIamPolicy", "resourcemanager.projects.setIamPolicy",
        "serviceusage.services.get", "serviceusage.services.enable", "firebase.projects.get", "firebase.projects.update",
        "firebase.clients.list", "firebase.clients.get", "firebase.clients.create", "firebaseappdistro.testers.list",
        "firebaseappdistro.testers.update", "firebaseappdistro.releases.list", "firebaseappdistro.releases.update",
        "cloudmessaging.messages.create"
    ];
    private static readonly string[] Services =
    [
        "cloudresourcemanager.googleapis.com", "serviceusage.googleapis.com", "firebase.googleapis.com",
        "firebaseinstallations.googleapis.com", "fcm.googleapis.com", "firebasecrashlytics.googleapis.com",
        "firebaseappdistribution.googleapis.com"
    ];

    public async Task<GoogleAccessReport> CheckAsync(string projectId, string? parent, CancellationToken ct = default)
    {
        if (!Regex.IsMatch(projectId, "^[a-z][a-z0-9-]{4,28}[a-z0-9]$") ||
            (parent != null && !Regex.IsMatch(parent, "^(folders|organizations)/[1-9][0-9]*$")))
            throw new ArgumentException("An explicit Google project ID and optional organization/folder resource are required.");
        List<GoogleAccessCheck> checks = [];
        async Task<JsonObject?> Read(string name, GoogleApi kind, string path, object? permissions = null)
        {
            try
            {
                var value = await api.SendAsync(kind, permissions == null ? HttpMethod.Get : HttpMethod.Post, path, permissions, ct);
                if (value == null) throw new InvalidOperationException("Missing diagnostic response.");
                return value;
            }
            catch (GoogleApiException error)
            {
                checks.Add(new(name, "unavailable", (int)error.StatusCode, []));
                return null;
            }
        }
        void PermissionResult(string name, JsonObject value, string[] requested)
        {
            var granted = (value["permissions"] as JsonArray ?? []).Select(x => x!.GetValue<string>()).ToHashSet(StringComparer.Ordinal);
            var missing = requested.Where(x => !granted.Contains(x)).Select(x => "missing:" + x).ToArray();
            checks.Add(new(name, missing.Length == 0 ? "passed" : "missing-permissions", 200,
                missing.Length == 0 ? requested.Select(x => "granted:" + x).ToArray() : missing));
        }
        var project = await Read("credential-project", GoogleApi.ResourceManager, "v3/projects/" + projectId);
        string? number = null;
        string? actualParent = null;
        if (project != null)
        {
            var resource = project["name"]?.GetValue<string>() ?? "";
            if (project["projectId"]?.GetValue<string>() != projectId || !Regex.IsMatch(resource, "^projects/[1-9][0-9]*$"))
                throw new InvalidOperationException("Diagnostic project identity mismatch.");
            number = resource["projects/".Length..];
            actualParent = project["parent"]?.GetValue<string>();
            checks.Add(new("credential-project", project["state"]?.GetValue<string>() == "ACTIVE" ? "passed" : "inactive", 200, []));
        }
        var policy = await Read("credential-project-permissions", GoogleApi.ResourceManager,
            "v3/projects/" + projectId + ":testIamPermissions", new { permissions = ProjectPermissions });
        if (policy != null) PermissionResult("credential-project-permissions", policy, ProjectPermissions);
        var firebase = await Read("firebase-project", GoogleApi.Firebase, "v1beta1/projects/" + projectId);
        if (firebase != null)
        {
            if (firebase["projectId"]?.GetValue<string>() != projectId ||
                (number != null && firebase["projectNumber"]?.GetValue<string>() != number))
                throw new InvalidOperationException("Diagnostic Firebase identity mismatch.");
            checks.Add(new("firebase-project", firebase["state"]?.GetValue<string>() == "ACTIVE" ? "passed" : "inactive", 200, []));
        }
        foreach (var service in Services)
        {
            var value = await Read(service, GoogleApi.ServiceUsage, $"v1/projects/{projectId}/services/{service}");
            if (value != null) checks.Add(new(service, value["state"]?.GetValue<string>() == "ENABLED" ? "passed" : "disabled", 200, []));
        }
        foreach (var kind in new[] { "androidApps", "iosApps" })
            await Count(kind, GoogleApi.Firebase, $"v1beta1/projects/{projectId}/{kind}", "apps");
        if (number != null) await Count("distribution-groups", GoogleApi.Distribution, $"v1/projects/{number}/groups", "groups");
        else checks.Add(new("distribution-groups", "not-checked", null, ["Credential project number unavailable."]));
        if (parent == null)
            checks.Add(new("target-parent-permissions", "not-configured", null, ["Provide the intended --parent; the credential project parent is never selected automatically."]));
        else
        {
            string[] requested = ["resourcemanager.projects.create"];
            var value = await Read("target-parent-permissions", GoogleApi.ResourceManager, "v3/" + parent + ":testIamPermissions", new { permissions = requested });
            if (value != null) PermissionResult("target-parent-permissions", value, requested);
        }
        return new(projectId, number, actualParent, parent, checks);

        async Task Count(string name, GoogleApi kind, string path, string collection)
        {
            HashSet<string> pages = [];
            string? token = null;
            var count = 0;
            do
            {
                var value = await Read(name, kind, path + "?pageSize=100" + (token == null ? "" : "&pageToken=" + GoogleRestClient.Segment(token)));
                if (value == null) return;
                count += (value[collection] as JsonArray)?.Count ?? 0;
                token = value["nextPageToken"]?.GetValue<string>();
                if (!string.IsNullOrEmpty(token) && (!pages.Add(token) || pages.Count > 100))
                    throw new InvalidOperationException("Diagnostic pagination did not terminate.");
            } while (!string.IsNullOrEmpty(token));
            checks.Add(new(name, "passed", 200, ["count:" + count]));
        }
    }
}
