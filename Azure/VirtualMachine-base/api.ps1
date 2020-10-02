# Azure DevOps API 

param(  
[string]$user = "", # Name of the user. THIS IS SUPPOSE TO BE EMPTY, LEAVE IT AS EMPTY
    
[Parameter(Mandatory = $true, HelpMessage="The Personal Access Token from Azure DevOps.")]
[string]$token # Personal Access Token From Azure DevOps

[Parameter(Mandatory = $false, HelpMessage="The default name for this is 'Whatever you want it to be'.")]    
[string]$releasePipelineName = "ReleasePipelinename", # This is the name of the Release Pipeline.
)
# User to authenicate in the API
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $Token)))




function getadoinfo {

# API URI - Gets info
$getinfo = "https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Consumption/pricesheets/default?api-version=2019-10-01"

# Invoke the get and return the answer
$getInfoResult = Invoke-RestMethod -Uri $getadoinfo -Method get -ContentType "application/json" -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo) }
return $getInfoResult
}


# API URI - Posts info
function postadoinfo {
$postBody = get-content ./releasedef.json
$PostBody = $postBody | convertfrom-json
#Populate the $postBody variables with the correct parameters

#for example the line below uses variables  
$body.name = $releasePipelineName 

# Convert Back to Json so we can send it to the API
$postBody = $postBody | Convertto-Json -Depth 100

$postInfo = "https://dev.azure.com/$organisation/$project/_apis/serviceendpoint/endpoints?api-version=5.0-preview.2"

$postInfoResult = Invoke-RestMethod -Uri $postInfo -Method post -body $PostBody -ContentType "application/json" -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo) }    
return $postInfoResults
}


#Microsoft ARM REST API

$ClientID       = "4b565304-99d0-4d41-8759-4b995e042f43" 
$ClientSecret   = "Hi-c:GCiC[/6CJ9e9AOOTsE5a[97l4[Z" 
$Tenant_id      = "7f429a9a-bd6a-4c3d-ac35-a100bd4644c8"
$subscriptionid = "206c6b04-b170-42cf-ab78-0703dbd83bdc"
function getBearer([string]$TenantID, [string]$ClientID, [string]$ClientSecret)
{
  $TokenEndpoint = {https://login.windows.net/{0}/oauth2/token} -f $TenantID 
  $ARMResource = "https://management.core.windows.net/";

  $Body = @{
          'resource'= $ARMResource
          'client_id' = $ClientID
          'grant_type' = 'client_credentials'
          'client_secret' = $ClientSecret
  }

  $params = @{
      ContentType = 'application/x-www-form-urlencoded'
      Headers = @{'accept'='application/json'}
      Body = $Body
      Method = 'Post'
      URI = $TokenEndpoint
  }

  $token = Invoke-RestMethod @params

  Return "Bearer " + ($token.access_token).ToString()
}



$token = getBearer $Tenant_id $ClientID $ClientSecret
Write-Output $token


# Now we have the bearer

# Here are some examples 
# Get a list of resource groups in your subscription

# Here is the API documentation
# https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/list

$getRGList = "https://management.azure.com/subscriptions/$subscriptionid/resourcegroups?api-version=2020-06-01"

$headers = @{
 
    'Host' = 'management.azure.com'
     
    'Content-Type' = 'application/json';
     
    'Authorization' = "$token";
     
    }

# Invoke the get and return the answer
$getRGListResult = Invoke-RestMethod -Uri $getRGList -Method get -Headers $headers
$getRGListResult

write-output $getRGListResult.value 

# Create a new Resource group in your subscription

# https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/createorupdate

$resourceGroupName = "Deathrace300"

$createRG = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/" + $resourceGroupName + "?api-version=2020-06-01"


$body = [PSCustomObject]@{
    "location" = "uksouth"
}

# convert request body object to a JSON string
 
$BodyJson = ConvertTo-Json -InputObject $Body -Depth 2
 
$headers = @{
 
    'Host' = 'management.azure.com'
    'Content-Type' = 'application/json';
    'Authorization' = "$token";
     
    }
 

# Invoke the get and return the answer
$CreateRGResult = Invoke-RestMethod -Uri $createRG -Method put -Headers $headers -Body $BodyJson
write-output $CreateRGResult

#examples of data for the body

    # construct request body object
     
$requestBody = [pscustomobject]@{
    sku = [pscustomobject]@{
    name = "davidthestorageaccount"
    } 
    kind = "Storage"
    location = "uk south"
    tags = [pscustomobject]@{
    key1 = "value1"
    key2 = "value2"
    } 
}  

$Data = @(
  [PSCustomObject]@{ UserName = "adam"; FirstName = "Adam"; LastName = "Driscoll" }
  [PSCustomObject]@{ UserName = "bruce"; FirstName = "Bruce"; LastName = "Willis" }
  [PSCustomObject]@{ UserName = "tom"; FirstName = "Tom"; LastName = "Hanks" }
)

#Microsoft Graph API

# Input Parameters  

$ClientID       = "4b565304-99d0-4d41-8759-4b995e042f43" 
$ClientSecret   = "Hi-c:GCiC[/6CJ9e9AOOTsE5a[97l4[Z" 
$Tenant_id      = "7f429a9a-bd6a-4c3d-ac35-a100bd4644c8"
$subscriptionid = "206c6b04-b170-42cf-ab78-0703dbd83bdc"
 
$tenantName = "pinport.io"  
$resource = "https://graph.microsoft.com/"  
$URL = "https://graph.microsoft.com/beta/groups?`$filter=resourceProvisioningOptions/Any(x:x eq 'Team')"  
$URL2 = "https://graph.microsoft.com/v1.0/security/alerts"
  
$tokenBody = @{  
    Grant_Type    = "client_credentials"  
    Scope         = "https://graph.microsoft.com/.default"  
    Client_Id     = $clientId  
    Client_Secret = $clientSecret  
}   
  
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $tokenBody  
$result = Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL2 -Method Get  
($result | select-object Value).Value | Select-Object id, displayName, visibility  