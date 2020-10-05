param(

    [Parameter(Mandatory = $true, HelpMessage="The name of the storage account.")]
    [string]$storageaccountname, 
    
    [Parameter(Mandatory = $true, HelpMessage="The name of the container.")]
    [string]$containername, 
    
    [Parameter(Mandatory = $true, HelpMessage="The name of the VM.")]
    [string]$vmname,
    
    [Parameter(Mandatory = $true, HelpMessage="The resource group name.")]
    [string]$resourcegroup 
)


$parameters = @{
    'configurationpath'     = '.\dwh.ps1'
    'resourcegroupname'     = $resourcegroup
    'storageaccountname'    = $storageaccountname
    'ContainerName'         = $containername
}

publish-azvmdscconfiguration @parameters -force -verbose


$parameters = @{
    'Version'                      = '2.76'
    'resourcegroupname'            = $resourcegroup
    'VMName'                       = $vmname
    'ArchivestorageAccountName'    = $storageaccountname
    'ArchiveContainerName'         = $containername
    'ArchiveBlobName'              = 'dwh.ps1.zip'
    'AutoUpdate'                   = $true
    'ConfigurationName'            = 'dwh' 
}

set-azvmdscextension @parameters -verbose

Get-AzVMDscExtensionStatus -ResourceGroupName $resourcegroup -VMName $vmname