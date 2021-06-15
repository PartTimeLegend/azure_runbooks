$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "

    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName

    "Logging in to Azure..."
    $connectionResult =  Connect-AzAccount -Tenant $servicePrincipalConnection.TenantID `
                             -ApplicationId $servicePrincipalConnection.ApplicationID   `
                             -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint `
                             -ServicePrincipal
    "Logged in."

}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

$apimDaySku = "Basic"
$apimNightSku = "Developer"
$dayStartTime = [DateTime]::ParseExact("07:00","HH:mm",$null).TimeOfDay
$dayEndTime = [DateTime]::ParseExact("19:00","HH:mm",$null).TimeOfDay
$currentUtcTimeofDay = (Get-Date).ToUniversalTime().TimeOfDay

if ($currentUtcTimeofDay -ge $dayStartTime -and $currentUtcTimeofDay -lt $dayEndTime)
{
  $apimSku = $apimDaySku
}
elseif ($currentUtcTimeofDay -lt $dayStartTime -and $currentUtcTimeofDay -ge $dayEndTime)
{
  $apimSku = $apimNightSku
}

function SkuApim 
{
    param (
        [Parameter(Mandatory=$true)]$sku,
        [Parameter(Mandatory=$true)]$resourceGroup,
        [Parameter(Mandatory=$true)]$resourceName
    )
    $apim = Get-AzApiManagement -ResourceGroupName 
    $apim.Sku = $sku
    Set-AzApiManagement -InputObject $apim
}

$apimInstances = @{
    "rg-apishared-staging-uks" = "apim-staging-uks"
    "rg-apishared-systest-uks" = "apim-systest-uks"
}

foreach ($apim in $apimInstances.GetEnumerator()) 
{
    Write-Output "$($apim.Name): $($apim.Value) : $($apimSku)"
    SkuApim $apimSku $apim.Name $apim.Value
}
