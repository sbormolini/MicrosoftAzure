using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace StorageQueueDemo
{
    public class ProcessMessage
    {
        [FunctionName("ProcessMessage")]
        public void Run(
            [QueueTrigger("myqueue-items", Connection = "AzureWebJobsStorage")]string myQueueItem, 
            ILogger log)
        {
            //log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");

            //// Instantiate a QueueClient which will be used to manipulate the queue
            //// https://docs.microsoft.com/en-us/azure/storage/queues/storage-dotnet-how-to-use-queues?tabs=dotnet
            //var connectionString = Environment.GetEnvironmentVariable("AzureWebJobsStorage", EnvironmentVariableTarget.Process);
            //QueueClient queueClient = new(connectionString, "myqueue-items");

            //if (queueClient.Exists())
            //{
            //    // Peek at the next message
            //    QueueMessage[] retrievedMessage = queueClient.ReceiveMessages();

            //    // Display the message
            //    foreach (var message in retrievedMessage)
            //    {
            //        var messageText = Encoding.UTF8.GetString(Convert.FromBase64String(message.MessageText));

            //        // todo validate json
            //        var task = JsonConvert.DeserializeObject<Message>(messageText);
            //        log.LogInformation($"Process Message: '{task}'");

            //        // remove message 
            //        if (task.CoraTaskId == "1002")
            //        {
            //            log.LogInformation($"Remove message: '{message.MessageId}'");
            //            queueClient.DeleteMessage(message.MessageId, message.PopReceipt);
            //        }
            //        // requeus?
            //    }
            //}

            log.LogInformation($"Processed message!");
        }
    }
}
