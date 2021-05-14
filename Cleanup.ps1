param(  
  [Parameter(Mandatory=$true)][bool]$dryRun=$true
)
# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process
$resources = Get-AzResource -Name *tmp*
function ConnectToAzureAutomation
{
  $connection = Get-AutomationConnection -Name AzureRunAsConnection
  while(!($connectionResult) -and ($logonAttempt -le 10))
  {
      $LogonAttempt++
      Write-FormattedOutput "Logging in to Azure attempt ${logonAttempt}" -ForegroundColor "Green"
      $connectionResult = Connect-AzAccount `
                              -ServicePrincipal `
                              -Tenant $connection.TenantID `
                              -ApplicationId $connection.ApplicationID `
                              -CertificateThumbprint $connection.CertificateThumbprint

      Start-Sleep -Seconds 30
  }
  if ($logonAttempt -gt 10)
  {
    Write-FormattedOutput "Logging in to Azure breached 10 attempts and failed." -ForegroundColor "Red"
  }
}

f
function DeleteResource
{
  param(  
    [Parameter(Mandatory=$true)]$resource
  )
  Write-FormattedOutput "INFO: Deleting ${resource.ResourceId}" -ForegroundColor "Green"
  switch ($resource.ResourceType)
  {
    "Microsoft.Compute/virtualMachines" 
    {
      if (Get-AzVMStatus $resource.ResourceGroupName $resource.Name -eq "VM running")
      {
        Stop-AzVM -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
      }
    }
    "Microsoft.Web/sites"
    {
      Remove-AzWebApp -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.Storage/storageContainers"
    {
      Remove-AzStorageContainer -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.Storage/storageAccounts"
    {
      Remove-AzStorageAccount -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.SignalRService/SignalR"
    {
      Remove-AzSignalR -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.Sql/servers/databases"
    {
      Remove-AzSqlDatabase -ResourceGroupName $resource.ResourceGroupName -ServerName $resource.ServerName -DatabaseName $resouce.DatabaseName
    }
    "Microsoft.Sql/servers"
    {
      Remove-AzSqlServer  -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.Insights/components"
    {
      Remove-AzApplicationInsights -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.Web/serverFarms"
    {
      Remove-AzAppServicePlan -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.DocumentDb/databaseAccounts"
    {
      Remove-AzCosmosDBAccount -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.Search/searchServices"
    {
      Remove-AzSearchService -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
    "Microsoft.ServiceBus/namespaces"
    {
      Remove-AzServiceBusNamespace -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
    }
  }
}
function Write-FormattedOutput
{
    [CmdletBinding()]
    Param(
         [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)][Object] $Object,
         [Parameter(Mandatory=$False)][ConsoleColor] $BackgroundColor,
         [Parameter(Mandatory=$False)][ConsoleColor] $ForegroundColor
    )    

    # save the current color
    $bc = $host.UI.RawUI.BackgroundColor
    $fc = $host.UI.RawUI.ForegroundColor

    # set the new color
    if($BackgroundColor -ne $null)
    { 
       $host.UI.RawUI.BackgroundColor = $BackgroundColor
    }

    if($ForegroundColor -ne $null)
    {
        $host.UI.RawUI.ForegroundColor = $ForegroundColor
    }

    Write-FormattedOutput $Object
  
    # restore the original color
    $host.UI.RawUI.BackgroundColor = $bc
    $host.UI.RawUI.ForegroundColor = $fc
}
ConnectToAzureAutomation # Establish runbook connection
foreach ($resource in $resources)
{
  # Delete this resource
  DeleteResource $resouce
}