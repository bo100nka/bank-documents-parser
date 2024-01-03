using bank_documents_parser;
using System.Reflection;
using System.Text.Json;

var context = "main";

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
    var config_path = GetConfigPath(current_path);
    var appSettings = GetConfig(jsonOptions, config_path);

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

string GetConfigPath(string? current_path)
{
    return Path.Combine(current_path, "appsettings.json");
}

AppSettings? GetConfig(JsonSerializerOptions jsonOptions, string config_path)
{
    var result = JsonSerializer.Deserialize<AppSettings>(File.ReadAllText(config_path), jsonOptions);
    Log.Info(context, $"Config: (appsettings.json):\n{JsonSerializer.Serialize(result, jsonOptions)}");
    return result;
}

static void Initialize(AppSettings? appSettings)
{
    Log.DebugMode = appSettings.DebugMode;
}