# Azure Container Instances - Contenedor Linux con IP pública


<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/101-aci-linuxcontainer-public-ip/PublicLastTestDate.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/101-aci-linuxcontainer-public-ip/PublicDeployment.svg" />&nbsp;

<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/101-aci-linuxcontainer-public-ip/FairfaxLastTestDate.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/101-aci-linuxcontainer-public-ip/FairfaxDeployment.svg" />&nbsp;

<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/101-aci-linuxcontainer-public-ip/BestPracticeResult.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/101-aci-linuxcontainer-public-ip/CredScanResult.svg" />&nbsp;

Esta plantilla muestra un caso de uso sencillo para [Azure Container Instances](https://docs.microsoft.com/es-es/azure/container-instances/).


<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fazure-quickstart-templates%2fmaster%2f101-aci-linuxcontainer-public-ip%2fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F101-function-app-create-dedicated%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


| NOMBRE DEL PARÁMETRO | DESCRIPCIÓN |
|  -- | -- |
| name | Nombre del grupo de contenedores.|
| image | Imagen de contenedor que se va a implementar. Debe tener el formato repoName/imagename:tag para las imágenes almacenadas en Docker Hub público o un URI completo para otros registros. Las imágenes de los registros privados requieren credenciales de registro adicionales. |
| port | Puerto para abrir en el contenedor y la dirección IP pública.|
| cpuCores | El número de núcleos de CPU que se asignarán al contenedor. |
| memoryInGb | La cantidad de memoria que se va a asignar al contenedor en gigabytes. |
| location | Ubicación de todos los recursos. |
| restartPolicy| El comportamiento de Azure Runtime si el contenedor se ha detenido. |
| | |


Uso de la plantilla
PowerShell

```PowerShell
New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> #use this command when you need to create a new resource group for your deployment
New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateUri https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/aci-linuxcontainer-public-ip/azuredeploy.json
```

[Instalar y configurar PowerShell de Azure](https://docs.microsoft.com/es-mx/powershell/azure/?view=azps-3.8.0)

Línea de comandos CLI

```PowerShell
az group create --name <resource-group-name> --location <resource-group-location> #use this command when you need to create a new resource group for your deployment
az group deployment create --resource-group <my-resource-group> --template-uri https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/aci-linuxcontainer-public-ip/azuredeploy.json
```

[Instalación y configuración de la interfaz de línea de comandos multiplataforma de Azure](https://docs.microsoft.com/es-mx/cli/azure/install-azure-cli)

