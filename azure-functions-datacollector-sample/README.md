# Azure Function to collect data for Data Collection Endpoint
Powershell Azure function which collects data from Storage Account and send it to a Data Collection Endpoint. 
From there the data will end via Data collection rule at a custom DCR-based log table in Log Analytics workspace.

![image](https://user-images.githubusercontent.com/86348794/187877895-0464d191-3329-4081-84d9-a1c281f5d1d3.png)

## Installation
1. Register application in Azure AD
2. Create data collection endpoint
3. Add custom log table
4. Assign permissions to DCR (managed identity of function app? > check)
4. Deploy & configure Function App

#### Source
- https://docs.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal
- https://docs.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview
