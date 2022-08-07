# Azure Function to collect data for Data Collection Endpoint
Powershell Azure function which collects data from Storage Account and send it to a Data Collection Endpoint. 
From there the data will end via Data collection rule at a custom DCR-based log table in Log Analytics workspace.

#### Source
- https://docs.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal
- https://docs.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview