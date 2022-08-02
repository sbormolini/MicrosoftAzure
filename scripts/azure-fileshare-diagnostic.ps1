$hashReplace = @{
    '%20'=' ';
    '%7B'='{';
    '%7D'='}';
    '%C3%A4'='ä';
    '%C3%AB'='ë';
    '%C3%B6'='ö';
    '%C3%BC'='ü'
}

function Get-FileshareCapacity
{
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$storageAccountName,

        [Parameter(Mandatory = $true)]
        [String]$storageAccountRGName,

        [Parameter(Mandatory = $true)]
        [String]$storageAccountKey
    )
    
    $context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
    $fileshares = Get-AzStorageShare -Context $context | Where-Object {$_.IsSnapshot -eq $false}
    
    foreach ($fileshare in $fileshares) 
    {
        $fileinfo = @{count=0;length=0}
        Write-Output ""
        Write-Output "File Share: $($fileshare.Name)"
        $usage = ((Get-AzRmStorageShare -ResourceGroupName $storageAccountRGName -StorageAccountName $storageAccountName -Name $fileshare.Name -GetShareUsage).ShareUsageBytes)/1073741824

        Write-Output "File Share Usage GB: $([math]::Round($usage,2))GB"
        Write-Output "File Share Usage %: $([math]::Round(($usage/$($fileshare.Quota))*100,2))%"
    }
}


function Get-SubDirectoryContents
{
    param
    (
        [Parameter(Mandatory = $true)]
        [Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageFileDirectory]$subDirectory,

        [Parameter(Mandatory = $true)]
        [Microsoft.WindowsAzure.Commands.Storage.AzureStorageContext]$context
    )

    $path = $subDirectory.CloudFileDirectory.Uri.PathAndQuery.Remove(0,($subDirectory.CloudFileDirectory.Uri.PathAndQuery.IndexOf('/',1)+1))
    foreach($key in $hashReplace.Keys)
    {
        $path = $path.Replace($key, $hashReplace.$key)
    }

    try
    {
        $rootContents = Get-AzStorageFile -ShareName $subDirectory.CloudFileDirectory.Share.Name -Path "$path" -Context $context -ErrorAction Stop | 
            Get-AzStorageFile -ErrorAction Stop

        foreach ($fsObj in $rootContents) 
        {
            if($fsObj.gettype().Name -eq 'AzureStorageFile')
            {
                Write-Output "File $($fsObj.Name)"
                $fileinfo["count"]++
                $fileinfo["length"]=$fileinfo["length"]+$fsObj.Length
            }
            elseif($fsObj.gettype().Name -eq 'AzureStorageFileDirectory')
            {
                Write-Output "Subfolder $($fsObj.Name)"
                Get-SubDirectoryContents $fsObj $context
            }
        }
    }
    catch
    {
        "PARSING ERROR: $($subDirectory.CloudFileDirectory.Share.Name) $path"
    }
}


Get-AzStorageAccount | ForEach-Object{
    $storageAccount = $_
    $storageAccountName = $storageAccount.StorageAccountName
    $storageAccountRGName = $storageAccount.ResourceGroupName
    $storageAccountKey = (Get-AzStorageAccountKey $storageAccount.ResourceGroupName $storageAccountName)[0].Value
    Write-Output "Storage Account: $storageAccountName : $($storageAccount.Sku.Name)"
    Get-FileshareCapacity $storageAccountName $storageAccountRGName $storageAccountKey
}
