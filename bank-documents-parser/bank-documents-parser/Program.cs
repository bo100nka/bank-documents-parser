using bank_documents_parser;
using System.Reflection;
using System.Text.Json;

var context = "main";

var jsonOptions = new JsonSerializerOptions 
{
	PropertyNameCaseInsensitive = true,
	WriteIndented = true,
	PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
};

try
{
    Log.Raw(new string('*', 120));
    Log.Info(context, "-----------------------");
    Log.Info(context, "Starting...");
    Log.Info(context, "-----------------------");

    var appDir = GetCurrentPath();
    var workDir = GetWorkingDirectory();
    var appSettings = CreateIfNotExistsAndReadConfigFile(jsonOptions, workDir, appDir);

    if (appSettings == null)
        throw new ApplicationException("Missing or invalid config file (appsettings.json)");

    Initialize(appSettings);
}
catch (Exception ex)
{
	Log.Error(context, ex, "Unexpected error while executing app - application will now shut down.");
}
finally
{
	Log.Info(context, "-----------------------");
	Log.Info(context, "Shutting down...");
	Log.Info(context, "-----------------------");
}

string? GetCurrentPath()
{
    var result = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
    Log.Info(context, $"Current path: {result}");
    return result;
}

string GetWorkingDirectory()
{
    return Path.Combine("c:", "YellowNET", "appsettings.json");
}

AppSettings? CreateIfNotExistsAndReadConfigFile(JsonSerializerOptions jsonOptions, string configPath, string appPath)
{
    var workDir = Path.GetDirectoryName(configPath);
    
    Log.Info(context, $"Checking working directory {workDir}...");
    if (!Directory.Exists(workDir))
    {
        Directory.CreateDirectory(workDir);
        Log.Info(context, $"Creating new working directory {workDir}...");
    }

    Log.Info(context, $"Checking config file {configPath}...");
    if (!File.Exists(configPath))
    {
        File.Copy(Path.Combine(appPath, "appsettings.json"), configPath);
        Log.Info(context, $"Creating new config file {configPath}...");
    }

    Log.Info(context, "Reading config file...");
    
    var result = JsonSerializer.Deserialize<AppSettings>(File.ReadAllText(configPath), jsonOptions);
    
    Log.Info(context, $"Using config:\n{JsonSerializer.Serialize(result, jsonOptions)}");
    
    return result;
}

static void Initialize(AppSettings? appSettings)
{
    Log.DebugMode = appSettings.DebugMode;
}