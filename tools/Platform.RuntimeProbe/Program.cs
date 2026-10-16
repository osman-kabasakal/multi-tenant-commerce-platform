using System.Runtime.InteropServices;

if (!OperatingSystem.IsLinux()) throw new PlatformNotSupportedException("The container runtime probe requires Linux.");
var runtime = Environment.GetEnvironmentVariable("XDG_RUNTIME_DIR");
if (string.IsNullOrWhiteSpace(runtime) || !Path.IsPathFullyQualified(runtime) || !Directory.Exists(runtime))
    throw new InvalidOperationException("Configure an existing private XDG runtime directory.");
if (new DirectoryInfo(runtime).LinkTarget != null || File.GetUnixFileMode(runtime) != (UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute))
    throw new InvalidOperationException("The XDG runtime directory must be a regular private 0700 directory.");
var probe = Path.Combine(runtime, "probe-" + Guid.NewGuid().ToString("N"));
try
{
    File.WriteAllText(probe, "runtime permission probe");
    using var mutex = new Mutex(false, "platform-picture-probe-" + Guid.NewGuid().ToString("N"));
    if (!mutex.WaitOne(TimeSpan.FromSeconds(5))) throw new InvalidOperationException("The runtime mutex did not become available.");
    mutex.ReleaseMutex();
    Console.WriteLine("PASS: " + RuntimeInformation.FrameworkDescription + " creates/releases the image mutex in its private writable runtime directory.");
}
finally { File.Delete(probe); }
