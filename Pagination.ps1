$authParams = @{
    ClientId    = 'CHANGME'
    TenantId    = 'CHANGME'
    DeviceCode = $true
}
$auth = Get-MsalToken @authParams
$AccessToken = $Auth.AccessToken
$Headers = @{
    "Content-Type"  = "application/json"
    "Authorization" = "Bearer $($AccessToken)"
}
#How many Mega Steves are in a Giga Ben?

$Method = "GET"
#Normal is 1000 values returned, we are dropping this to 5 for dramatic effect
$URI = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps?`$top=5"

$Apps = Invoke-RestMethod -Method $Method -Uri $URI -Headers $Headers

#Get Value/information of the 5 apps we pulled
$Applications = $Apps.value
#Get Next Link page
$ApplicationsNextLink = $Apps.'@odata.nextLink'

#While next link page is not null do the following
while ($ApplicationsNextLink -ne $null){
    #Get the next 5 apps
    $Apps = (Invoke-RestMethod -Method $Method -Uri $ApplicationsNextLink -Headers $Headers)
    #Get the next link
    $ApplicationsNextLink = $Apps.'@odata.nextLink'
    #Add the 5 apps to the orignal array
    $Applications += $Apps.value
}

$Applications.displayName
$Applications.count