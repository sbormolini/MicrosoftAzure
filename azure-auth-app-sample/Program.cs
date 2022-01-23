using System.Threading.Tasks;
using Microsoft.Identity.Client;

namespace azure_auth_app_sample;

// source https://docs.microsoft.com/en-us/learn/modules/implement-authentication-by-using-microsoft-authentication-library/4-interactive-authentication-msal
class Program
{
    private const string _clientId = "APPLICATION_CLIENT_ID";
    private const string _tenantId = "DIRECTORY_TENANT_ID";

    public static async Task Main(string[] args)
    {
        var app = PublicClientApplicationBuilder
            .Create(_clientId)
            .WithAuthority(AzureCloudInstance.AzurePublic, _tenantId)
            .WithRedirectUri("http://localhost")
            .Build();
        string[] scopes = { "user.read" };
        AuthenticationResult result = await app.AcquireTokenInteractive(scopes).ExecuteAsync();

        Console.WriteLine($"Token:\t{result.AccessToken}");
    }
}