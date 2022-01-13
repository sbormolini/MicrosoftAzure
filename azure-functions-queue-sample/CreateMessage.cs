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
using Microsoft.Azure.Storage.Queue;

namespace StorageQueueDemo
{
    public static class CreateMessage
    {
        [FunctionName("CreateMessage")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            //[Queue("myqueue-items", Connection = "AzureWebJobsStorage")] QueueClient outputQueue,
            [Queue("myqueue-items", Connection = "AzureWebJobsStorage")] CloudQueue outputQueue,
            ILogger log)
        {
            //log.LogInformation("C# HTTP trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
    
            Message message = new()
            { 
                ServiceProvider1TicketId = data?.sp1Id,
                ServiceProvider2TicketId = data?.sp2Id,
                CreationDate = DateTime.UtcNow
            };
            log.LogInformation($"Created {message}");

            log.LogInformation("Add message with 1 min visibility timeout");
            var cqm = new CloudQueueMessage(JsonConvert.SerializeObject(message));
            outputQueue.AddMessage(cqm, initialVisibilityDelay: TimeSpan.FromMinutes(1));

            //outputQueue.SendMessage(JsonConvert.SerializeObject(message), TimeSpan.FromMinutes(1));

            return new OkObjectResult("Added message to 'myqueue-items'");
        }
    }
}
