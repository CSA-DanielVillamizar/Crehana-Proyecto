$resourceGroupName = Read-Host -Prompt "Escriba un nombre de grupo de recursos que se utilice para generar nombres de recursos"
$location = Read-Host -Prompt "Introduzca la ubicación (Como 'eastus' or 'northeurope')"
$templateUri = "https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/function-app-create-dynamic/azuredeploy.json"

New-AzResourceGroup -Name $resourceGroupName -Location "$location"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri

Read-Host -Prompt "Pulse [ENTER] para continuar ..."


# Eliminar recuros az group delete --name <RESOURCE_GROUP_NAME>