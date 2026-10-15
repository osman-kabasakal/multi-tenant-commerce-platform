using System.Text.RegularExpressions;
using SaasManager.Application.Common.Interfaces.FileStorage;

namespace SaasManager.Infrastructure.FileStorage;

public sealed class FileSystemStorageOptions
{
    public string RootDirectory { get; init; } = "";
    public long MaxFileBytes { get; init; } = 512L * 1024 * 1024;
    public void Validate()
    {
        if (!Path.IsPathFullyQualified(RootDirectory) || Path.GetFullPath(RootDirectory) == Path.GetPathRoot(RootDirectory) ||
            MaxFileBytes is < 1 or > 4L * 1024 * 1024 * 1024)
            throw new InvalidOperationException("Configure a private absolute file-storage directory and a supported upload limit.");
    }
}

/// <summary>Private files shared by replicas through a persistent volume. References are not public URLs.</summary>
public sealed class FileSystemBlobStorageService : IBlobStorageService
{
    public const string Prefix = "pfile:v1:";
    private readonly FileSystemStorageOptions options;
    private readonly string root;
    public FileSystemBlobStorageService(FileSystemStorageOptions options)
    {
        options.Validate(); this.options = options; root = Path.TrimEndingDirectorySeparator(Path.GetFullPath(options.RootDirectory));
        NoLink(root); CreateDirectory(root); NoLink(root);
    }

    private static void Segment(string name)
    {
        if (!Regex.IsMatch(name, "^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$") || name is "." or "..")
            throw new ArgumentException("Invalid file-storage path segment.");
    }
    private static string Key(string fileName, string? directory)
    {
        Segment(fileName);
        if (directory == null || directory == "") return fileName;
        var segments = directory.Split('/');
        foreach (var segment in segments) Segment(segment);
        return string.Join('/', segments.Append(fileName));
    }
    private string PathFor(string container, string key)
    {
        Segment(container);
        if (!Regex.IsMatch(container,"^[a-z][a-z0-9-]{2,62}$")) throw new ArgumentException("Invalid storage container.");
        var segments = key.Split('/'); foreach (var segment in segments) Segment(segment);
        var path = root;
        NoLink(path);
        foreach (var segment in new[] {container}.Concat(segments)) { path = Path.Combine(path,segment); NoLink(path); }
        return path;
    }
    private static void NoLink(string path)
    {
        if ((File.Exists(path) || Directory.Exists(path)) && (File.GetAttributes(path) & FileAttributes.ReparsePoint) != 0)
            throw new InvalidOperationException("File-storage symbolic links are not supported.");
        // Detect dangling links too.
        if (new FileInfo(path).LinkTarget != null || new DirectoryInfo(path).LinkTarget != null)
            throw new InvalidOperationException("File-storage symbolic links are not supported.");
    }
    private static void CreateDirectory(string path)
    {
        if (OperatingSystem.IsWindows()) Directory.CreateDirectory(path);
        else Directory.CreateDirectory(path,UnixFileMode.UserRead|UnixFileMode.UserWrite|UnixFileMode.UserExecute);
    }

    public async Task<string> UploadFileAsync(Stream stream,string fileName,string container,string? directory=null,CancellationToken ct=default)
    {
        ct.ThrowIfCancellationRequested();
        var key=Key(fileName,directory);var path=PathFor(container,key);var parent=Path.GetDirectoryName(path)!;
        CreateDirectory(parent);PathFor(container,key);
        var temporary=Path.Combine(parent,"."+Guid.NewGuid().ToString("N")+".tmp");
        try
        {
            var fileOptions=new FileStreamOptions{Mode=FileMode.CreateNew,Access=FileAccess.Write,Share=FileShare.None,Options=FileOptions.Asynchronous};
            if(!OperatingSystem.IsWindows())fileOptions.UnixCreateMode=UnixFileMode.UserRead|UnixFileMode.UserWrite;
            await using(var output=new FileStream(temporary,fileOptions))
            {
                var buffer=new byte[81920];long size=0;int read;
                while((read=await stream.ReadAsync(buffer,ct))!=0)
                {
                    size+=read;if(size>options.MaxFileBytes)throw new InvalidOperationException("The stored file exceeds the configured size limit.");
                    await output.WriteAsync(buffer.AsMemory(0,read),ct);
                }
                await output.FlushAsync(ct);
            }
            ct.ThrowIfCancellationRequested();PathFor(container,key);File.Move(temporary,path,true);
        }
        finally{if(File.Exists(temporary))File.Delete(temporary);}
        return Prefix+container+"/"+key;
    }

    public Task<bool> DeleteFileAsync(string key,string container,CancellationToken ct=default)
    {
        ct.ThrowIfCancellationRequested();var path=PathFor(container,key);var exists=File.Exists(path);if(exists)File.Delete(path);return Task.FromResult(exists);
    }
    public Task<bool> ContainerExistsAsync(string container,CancellationToken ct=default)
    {
        ct.ThrowIfCancellationRequested();var path=PathFor(container,"probe");return Task.FromResult(Directory.Exists(Path.GetDirectoryName(path)));
    }
    public Task<StoredFileDownload> DownloadFileAsync(string reference,CancellationToken ct=default)
    {
        ct.ThrowIfCancellationRequested();
        if(!reference.StartsWith(Prefix,StringComparison.Ordinal))throw new InvalidOperationException("Unsupported storage reference; select its provider or migrate explicitly.");
        var parts=reference[Prefix.Length..].Split('/',2);if(parts.Length!=2)throw new ArgumentException("Invalid storage reference.");
        var path=PathFor(parts[0],parts[1]);
        var content=new FileStream(path,FileMode.Open,FileAccess.Read,FileShare.Read|FileShare.Delete,81920,FileOptions.Asynchronous|FileOptions.SequentialScan);
        return Task.FromResult(new StoredFileDownload(content,content.Length,StoredFileDownload.ContentTypeFor(path)));
    }
}
