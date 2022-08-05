# h1 PowerShell Azure Function
Run http function with custom PS Module

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