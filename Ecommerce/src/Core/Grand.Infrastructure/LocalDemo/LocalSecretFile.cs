using System.Security.Cryptography;

namespace Grand.Infrastructure.LocalDemo;

/// <summary>Publish a complete key atomically when several demo processes start together.</summary>
public static class LocalSecretFile
{
    public static byte[] GetOrCreate(string path, Func<byte[]> generate)
    {
        var mutexName = "commerce-demo-" + Convert.ToHexString(SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(Path.GetFullPath(path))));
        using var mutex = new Mutex(false, mutexName);
        var acquired = false;
        try
        {
            try { acquired = mutex.WaitOne(TimeSpan.FromSeconds(10)); }
            catch (AbandonedMutexException) { acquired = true; }
            if (!acquired) throw new IOException("Timed out creating local demo key.");
            return CreateUnderLock(path, generate);
        }
        finally { if (acquired) mutex.ReleaseMutex(); }
    }

    private static byte[] CreateUnderLock(string path, Func<byte[]> generate)
    {
        if (File.Exists(path)) return File.ReadAllBytes(path);
        var temporary = path + "." + Convert.ToHexString(RandomNumberGenerator.GetBytes(8)) + ".tmp";
        try
        {
            using (var file = new FileStream(temporary, new FileStreamOptions {
                Mode = FileMode.CreateNew, Access = FileAccess.Write, Share = FileShare.None,
                UnixCreateMode = OperatingSystem.IsWindows() ? null : UnixFileMode.UserRead | UnixFileMode.UserWrite
            }))
            {
                file.Write(generate());
                file.Flush(true);
            }
            try { File.Move(temporary, path, false); }
            catch (IOException) when (File.Exists(path)) { }
            return File.ReadAllBytes(path);
        }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
    }
}
