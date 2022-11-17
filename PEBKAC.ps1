$authParams = @{
    ClientId    = 'CHANGEME'
    TenantId    = 'CHANGEME'
    DeviceCode = $true
}
$auth = Get-MsalToken @authParams
$AccessToken = $Auth.AccessToken
$Headers = @{
    "Content-Type"  = "application/json"
    "Authorization" = "Bearer $($AccessToken)"
}
#How many Mega Steves are in a Giga Ben
$Bytes = 30GB
$Method = "Get"
$URI = "https://graph.microsoft.com/beta/deviceManagement/manageddevices?freeStorageSpaceInBytes le $Bytes"

$Devices= Invoke-RestMethod  -Method $Method -URI $URI -Headers $Headers
$QueriedDevices = @()
foreach ($Device in $Devices){
    $DeviceToAdd = $Device.value.azureADDeviceId
    $QueriedDevices += $DeviceToAdd
}

foreach ($AADDevice in $QueriedDevices){
$URI2 = "https://graph.microsoft.com/beta/devices?`$filter=deviceId eq '$($AADDevice)'"
$AADDevicesQuery= Invoke-RestMethod  -Method $Method -URI $URI2 -Headers $Headers
$AADDeviceQ = $AADDevicesQuery.value.id
$URI3 = "https://graph.microsoft.com/beta/devices/$AADDeviceQ"
$Body = @{
    extensionAttributes = @{
    extensionAttribute1 = "PEBKAC"
    }
}
$Body = $Body | ConvertTo-Json
Invoke-RestMethod -Method "PATCH" -URI $URI3 -Headers $Headers -Body $Body
}