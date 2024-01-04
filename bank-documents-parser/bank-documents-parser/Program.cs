using bank_documents_parser;
using System.Reflection;
using System.Text.Json;

var context = "main";

Log.Raw(new string('*', 120));
Log.Info(context, "-----------------------");
Log.Info(context, "Starting...");
Log.Info(context, "-----------------------");

var jsonOptions = new JsonSerializerOptions 
{
	PropertyNameCaseInsensitive = true,
	WriteIndented = true,
	PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
};

try
{
    var current_path = GetCurrentPath();
    var config_path = GetConfigPath();
    var appSettings = GetConfig(jsonOptions, config_path, current_path);

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

string GetConfigPath()
{
    return Path.Combine("c:", "YellowNET", "appsettings.json");
}

AppSettings? GetConfig(JsonSerializerOptions jsonOptions, string config_path, string appPath)
{
    var config_dir = Path.GetDirectoryName(config_path);
    
    Log.Info(context, $"Checking config directory {config_dir}...");
    if (!Directory.Exists(config_dir))
    {
        Directory.CreateDirectory(config_dir);
        Log.Info(context, $"Creating new directory {config_dir}...");
    }

    Log.Info(context, $"Checking config file {config_path}...");
    if (!File.Exists(config_path))
    {
        File.Copy(Path.Combine(appPath, "appsettings.json"), config_path);
        Log.Info(context, $"Creating new config file {config_path}...");
    }

    Log.Info(context, "Reading config file...");
    
    var result = JsonSerializer.Deserialize<AppSettings>(File.ReadAllText(config_path), jsonOptions);
    
    Log.Info(context, $"Using config:\n{JsonSerializer.Serialize(result, jsonOptions)}");
    
    return result;
}

static void Initialize(AppSettings? appSettings)
{
    Log.DebugMode = appSettings.DebugMode;
}