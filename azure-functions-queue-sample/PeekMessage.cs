using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Azure.Storage.Queues;
using Azure.Storage.Queues.Models;
using System.Linq;

namespace StorageQueueDemo
{
    public static class PeekMessage
    {
        [FunctionName("PeekMessage")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            int index = data?.index is null ? 0 : data?.index;

            QueueClient queueClient = new(
                Environment.GetEnvironmentVariable("AzureWebJobsStorage", EnvironmentVariableTarget.Process),
                "myqueue-items");

            string response = null;

            if (queueClient.Exists())
            {
                PeekedMessage[] peekedMessage = queueClient.PeekMessages();
                response = peekedMessage.Any() 
                    ? $"Peeked message at {index}: {peekedMessage[index].Body}" 
                    : "No message";
            }

            return new OkObjectResult(response);
        }
    }
}
