# azure-functions-docker-sample
Azure Functions running in container sample


[Create a function on Linux using a custom container](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?tabs=in-process%2Cbash%2Cazure-cli&pivots=programming-language-csharp)


> func init --worker-runtime dotnet --docker


### run image
> docker run -p 8080:80 -it <docker_id>/azurefunctionsimage:v1.0.0
