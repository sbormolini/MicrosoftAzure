using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using StorageQueueDemo.Excpetions;

namespace StorageQueueDemo
{
    public class ProcessMessage
    {
        [FunctionName("ProcessMessage")]
        public void Run(
            [QueueTrigger("myqueue-itemsl", Connection = "AzureWebJobsStorage")]string queueItem, 
            ILogger log)
        {
            log.LogInformation($"C# Queue trigger function processed: {queueItem}");
            // https://docs.microsoft.com/en-us/azure/storage/queues/storage-dotnet-how-to-use-queues?tabs=dotnet

            var message = JsonConvert.DeserializeObject<Message>(queueItem);
            if (message.ServiceProvider1TicketId == "12345")
            {
                log.LogWarning("Ticket has not been processd yet!");
                throw new NotProcessedException("Ticket has not been processd yet!");
            }
        }
    }
}
