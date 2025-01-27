param (
    [string]$subscriptionId,
    [string]$bicepFilePath = "./main.bicep"
)

New-AzSubscriptionDeployment -Location westeurope -TemplateFile $bicepFilePath
