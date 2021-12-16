using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Internal;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Microsoft.Extensions.Logging.Abstractions;
using Xunit;

namespace TestFunctionAppLearn
{
    public class TestSayHello
    {
        [Fact]
        public void Run_Success()
        {
            var queryStringValue = "Lia";
            var request = new DefaultHttpRequest(new DefaultHttpContext())
            {
                Query = new QueryCollection
                (
                    new System.Collections.Generic.Dictionary<string, StringValues>()
                    {
                        { "name", queryStringValue }
                    }
                )
            };

            var logger = NullLoggerFactory.Instance.CreateLogger("Null Logger");

            var response = FunctionAppLearn.SayHello.Run(request, logger);
            response.Wait();

            // Check that the response is an "OK" response
            Assert.IsAssignableFrom<OkObjectResult>(response.Result);

            // Check that the contents of the response are the expected contents
            var result = (OkObjectResult)response.Result;
            string name = "Lia";
            string should = $"Hello, {name}. This HTTP triggered function executed successfully.";
            Assert.Equal(should, result.Value);
        }

        /*
        [Fact]
        public void Function_FailureNoQueryString()
        {
            var request = new DefaultHttpRequest(new DefaultHttpContext());
            var logger = NullLoggerFactory.Instance.CreateLogger("Null Logger");

            var response = FunctionAppLearn.SayHello.Run(request, logger);
            response.Wait();

            // Check that the response is an "Bad" response
            Assert.IsAssignableFrom<BadRequestObjectResult>(response.Result);

            // Check that the contents of the response are the expected contents
            var result = (BadRequestObjectResult)response.Result;
            Assert.Equal("This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.", result.Value);
        }
        */

        [Fact]
        public void Run_SuccessNoNameProperty()
        {
            var queryStringValue = "Sandro";
            var request = new DefaultHttpRequest(new DefaultHttpContext())
            {
                Query = new QueryCollection
                (
                    new System.Collections.Generic.Dictionary<string, StringValues>()
                    {
                        { "id", queryStringValue }
                    }
                )
            };

            var logger = NullLoggerFactory.Instance.CreateLogger("Null Logger");

            var response = FunctionAppLearn.SayHello.Run(request, logger);
            response.Wait();

            // Check that the response is an "Ok" response
            Assert.IsAssignableFrom<OkObjectResult>(response.Result);

            // Check that the contents of the response are the expected contents
            var result = (OkObjectResult)response.Result;
            Assert.Equal("This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.", result.Value);
        }
    }
}
