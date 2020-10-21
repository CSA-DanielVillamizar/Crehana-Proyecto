# Aprovisionar una aplicación de función en un plan de consumo

**Importante: si utiliza un plan de App Service, use https://github.com/CSA-DanielVillamizar/Crehana-Proyecto/tree/master/Recursos/function-app-create-dedicated en lugar de**

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazure%2Fazure-quickstart-templates%2Fmaster%2F101-function-app-create-dynamic%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F101-function-app-create-dynamic%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

Las funciones de Azure son una solución para ejecutar fácilmente pequeños fragmentos de código o "funciones" en la nube. Puede escribir solo el código que necesita para el problema en cuestión, sin preocuparse por toda una aplicación o la infraestructura para ejecutarlo. Para obtener más información acerca de Azure Functions, consulte [Azure Functions Overview](https://docs.microsoft.com/es-es/azure/azure-functions/functions-overview).


Esta plantilla aprovisiona una aplicación de función en un plan de consumo, que es un plan de hospedaje dinámico. La aplicación se ejecuta a petición y se le factura por ejecución, sin compromiso de recursos permanentes. Hay otras plantillas disponibles para el aprovisionamiento en un plan de hospedaje dedicado.

Parámetros
NOMBRE DEL PARÁMETRO	DESCRIPCIÓN
appName	The name of the function app that you wish to create.
storageAccountType	Storage Account type
location	Location for all resources.
runtime	The language worker runtime to load in the function app.
