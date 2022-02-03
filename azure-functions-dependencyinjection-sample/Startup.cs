using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;

[assembly: FunctionsStartup(typeof(azure_functions_dependencyinjection_sample.Startup))]

namespace azure_functions_dependencyinjection_sample
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            builder.Services.AddHttpClient();

            builder.Services.AddSingleton<ITipService>((s) => {
                return new TipService();
            });
        }
    }
}
