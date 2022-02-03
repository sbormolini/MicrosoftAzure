using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;

namespace azure_functions_dependencyinjection_sample
{
    public  class Function1
    {
        private readonly HttpClient _client;
        private readonly ITipService _service;

        public Function1(IHttpClientFactory httpClientFactory, ITipService service)
        {
            _client = httpClientFactory.CreateClient();
            _service = service;
        }

        [FunctionName("Function1")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var url = _service.GetTip();
            var response = await _client.GetAsync(url);

            if (response.StatusCode == System.Net.HttpStatusCode.OK)
                return new RedirectResult(url);
            else
                return new NotFoundResult();
        }
    }
}
