# PowerShell Azure Function with custom PS Module
Add custom PS Module to your project to use it in all functions of the function app:

```
FunctionApp
 | - host.json
 | - profile.ps1
 | - Modules
 | | - AzFunc.Helper
 | | | - AzFunc.Helper.psm1
 | | | - AzFunc.Helper.psd1
... (etc)
 | - NewRandomPassword
 | | - function.json
 | | - run.ps1
 ```