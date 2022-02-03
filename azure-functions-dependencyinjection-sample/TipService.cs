using System;

namespace azure_functions_dependencyinjection_sample;

public class TipService : ITipService
{
    public string GetTip()
    {
        Random tipNumber = new();
        return "https://microsoft.github.io/AzureTipsAndTricks/blog/tip" + tipNumber.Next(1, 335) + ".html";
    }
}
