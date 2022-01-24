using Microsoft.Graph;
using Azure.Identity;
using Microsoft.Identity.Client;

namespace azure_graph_sample;

// source https://docs.microsoft.com/en-us/learn/modules/microsoft-graph/4-microsoft-graph-sdk
// new implementation https://stackoverflow.com/questions/62696897/where-is-devicecodeprovider
class Program 
{
    public static async void Main(string[] args)
    {
        var scopes = new[] { "User.Read" };
        var tenantId = "someString";
        var clientId = "someString";

        // new implementation
        var deviceCodeCredential = new DeviceCodeCredential(
            new DeviceCodeCredentialOptions() {
                TenantId = tenantId,
                ClientId = clientId
            });

        var graphClient = new GraphServiceClient(deviceCodeCredential, scopes);
        var me = await graphClient.Me.Request().GetAsync();

        Console.WriteLine(me.DisplayName);
    }
}