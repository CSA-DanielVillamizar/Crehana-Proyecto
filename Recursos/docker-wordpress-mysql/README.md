# Deployment of WordPress+MySQL Containers with Docker Compose

<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/docker-wordpress-mysql/PublicLastTestDate.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/docker-wordpress-mysql/PublicDeployment.svg" />&nbsp;

<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/docker-wordpress-mysql/FairfaxLastTestDate.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/docker-wordpress-mysql/FairfaxDeployment.svg" />&nbsp;

<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/docker-wordpress-mysql/BestPracticeResult.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/docker-wordpress-mysql/CredScanResult.svg" />&nbsp;

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fdocker-wordpress-mysql%2Fazuredeploy.json" target="_blank">
	<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fdocker-wordpress-mysql%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

Esta plantilla le permite implementar una máquina virtual Ubuntu Server 16.04.0-LTS con Docker (mediante la [Extensión de Docker][ext])
e inicia un contenedor de WordPress escuchando un puerto 80 que utiliza la base de datos MySQL que se ejecuta
en un contenedor Docker independiente pero vinculado, que se crean mediante [Docker Compose][componer]
capacidades de la [Extensión de Docker de Azure][ext].


[ext]: https://github.com/Azure/azure-docker-extension
[compose]: https://docs.docker.com/compose


| NOMBRE DEL PARÁMETRO | DESCRIPCIÓN |
|  -- | -- |
| newStorageAccountName | Nombre DNS único para la cuenta de almacenamiento donde se colocarán los discos de la máquina virtual.|
| mysqlPassword| Contraseña de contraseña raíz para la base de datos MySQL. |
| adminUsername | Nombre de usuario de la máquina virtual.|
| dnsNameForPublicIP | Nombre DNS único para la IP pública utilizada para acceder a la máquina virtual. |
| location| Ubicación de todos los recursos. |
| authenticationType| Tipo de autenticación que se usará en la máquina virtual. Se recomienda la clave SSH. |
| adminPasswordOrKey| Clave SSH o contraseña para la máquina virtual. Se recomienda la clave SSH. |
| vmSize| Tamaño de la máquina virtual. |
| | |


Uso de la plantilla
PowerShell

```PowerShell
New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> #use this command when you need to create a new resource group for your deployment
New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateUri https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/docker-wordpress-mysql/azuredeploy.json
```

[Instalar y configurar PowerShell de Azure](https://docs.microsoft.com/es-mx/powershell/azure/?view=azps-3.8.0)

Línea de comandos CLI

```PowerShell
az group create --name <resource-group-name> --location <resource-group-location> #use this command when you need to create a new resource group for your deployment
az group deployment create --resource-group <my-resource-group> --template-uri https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/docker-wordpress-mysql/azuredeploy.json
```

[Instalación y configuración de la interfaz de línea de comandos multiplataforma de Azure](https://docs.microsoft.com/es-mx/cli/azure/install-azure-cli)



