using System.Text;
using Microsoft.Extensions.Hosting;

public class JobOutputStore
{
    private readonly IHostEnvironment _environment;
    private readonly Dictionary<string, StringBuilder> _outputStore = new();
    private readonly object _lock = new();

    public JobOutputStore(
        IHostEnvironment environment
    )
    {
        _environment = environment;
    }

    public void AppendOutput(string jobId, string output)
    {
        lock (_lock)
        {
            if (!_outputStore.ContainsKey(jobId))
            {
                _outputStore[jobId] = new StringBuilder();
            }

            _outputStore[jobId].AppendLine(output);
        }
    }

    public string GetOutput(string jobId)
    {
        lock (_lock)
        {
            return _outputStore.TryGetValue(jobId, out var output) ? output.ToString() : "No output available";
        }
    }

    public void ClearOutput(string jobId)
    {
        lock (_lock)
        {
            _outputStore.Remove(jobId);
        }
    }

    public void SaveOutput(string jobId, string storeName)
    {
        var rootPath = _environment.ContentRootPath;
        if (_environment.IsDevelopment())
        {
            rootPath = Directory.GetParent(rootPath).Parent.Parent.FullName;
        }

        if (!Directory.Exists(Path.Combine(rootPath, "Logs")))
        {
            Directory.CreateDirectory(Path.Combine(rootPath, "Logs"));
        }

        File.WriteAllText(Path.Combine(rootPath, "Logs", $"{storeName}-{jobId}.log"), GetOutput(jobId));
    }
}