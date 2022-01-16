using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Azure.Storage;
using Azure.Storage.Queues;
using Azure.Storage.Queues.Models;

namespace StorageQueueDemo
{
    public static class DeleteMessage
    {
        [FunctionName("DeleteMessage")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
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

            // https://docs.microsoft.com/en-us/java/api/com.azure.storage.queue.queueclient.deletemessage?view=azure-java-stable
            if (queueClient.Exists())
            {
                // delete
                // Get the next 10 messages from the queue
                foreach (DequeuedMessage message in queueClient.DequeueMessages(maxMessages: 10).Value)
                {
                    // "Process" the message
                    Console.WriteLine(message.MessageText);

                    // Let the service know we finished with the message and
                    // it can be safely deleted.
                    queueClient.DeleteMessage(message.MessageId, message.PopReceipt);
                }
            }

            return new OkObjectResult(response);
        }
    }
}
