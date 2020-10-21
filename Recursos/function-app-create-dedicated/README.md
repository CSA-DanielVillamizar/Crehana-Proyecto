# Aprovisionar una aplicación de función que se ejecuta en un plan de App Service

**Importante: si utiliza el modo Consumo, utilice https://github.com/CSA-DanielVillamizar/Crehana-Proyecto/tree/master/Recursos/function-app-create-dynamic en lugar de**

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazure%2Fazure-quickstart-templates%2Fmaster%2F101-function-app-create-dedicated%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F101-function-app-create-dedicated%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

Las funciones de Azure son una solución para ejecutar fácilmente pequeños fragmentos de código o "funciones" en la nube. Puede escribir solo el código que necesita para el problema en cuestión, sin preocuparse por toda una aplicación o la infraestructura para ejecutarlo. Para obtener más información acerca de Azure Functions, consulte [Azure Functions Overview](https://docs.microsoft.com/es-es/azure/azure-functions/functions-overview).


Esta plantilla aprovisiona una aplicación de función en un plan de consumo, que es un plan de hospedaje dinámico. La aplicación se ejecuta a petición y se le factura por ejecución, sin compromiso de recursos permanentes. Hay otras plantillas disponibles para el aprovisionamiento en un plan de hospedaje dedicado.


| NOMBRE DEL PARÁMETRO | DESCRIPCIÓN |
|  -- | -- |
| appName | El nombre de la aplicación de función que desea crear.|
| sku | El plan de tarifa para el plan de hospedaje. |
| workerSize | El tamaño de instancia del plan de hospedaje (pequeño, mediano o grande).|
| storageAccountType | Tipo de cuenta de almacenamiento. |
| location| Ubicación de todos los recursos. |
| | |


Uso de la plantilla
PowerShell

```PowerShell
New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> #use this command when you need to create a new resource group for your deployment
New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateUri https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/function-app-create-dedicated/azuredeploy.json
```

[Instalar y configurar PowerShell de Azure](https://docs.microsoft.com/es-mx/powershell/azure/?view=azps-3.8.0)

Línea de comandos CLI

```PowerShell
az group create --name <resource-group-name> --location <resource-group-location> #use this command when you need to create a new resource group for your deployment
az group deployment create --resource-group <my-resource-group> --template-uri https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/function-app-create-dedicated/azuredeploy.json
```

[Instalación y configuración de la interfaz de línea de comandos multiplataforma de Azure](https://docs.microsoft.com/es-mx/cli/azure/install-azure-cli)

