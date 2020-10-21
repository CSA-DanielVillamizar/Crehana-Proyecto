<# Definición
Azure App Service es un servicio basado en HTTP para hospedar aplicaciones web, API REST y 
back-ends para dispositivos móviles. Puede desarrollarlo en su lenguaje preferido, ya sea. 
NET, .NET Core, Java, Ruby, Node.js, PHP o Python. Las aplicaciones se ejecutan y escalan 
fácilmente en los entornos basados tanto en Windows como en Linux.

App Service no solo agrega a la aplicación la funcionalidad de Microsoft Azure, como la 
seguridad, el equilibrio de carga, el escalado automático y la administración automatizada. 
También puede sacar partido de sus funcionalidades de DevOps, por ejemplo, la implementación
continua desde Azure DevOps, GitHub, Docker Hub y otros orígenes, la administración de 
paquetes, entornos de ensayo, dominio personalizado y certificados TLS/SSL.

Varios lenguajes y plataformas: App Service tiene compatibilidad de primera clase con 
ASP.NET, ASP.NET Core, Java, Ruby, Node.js, PHP o Python.

#>

# Iniciar Sesión
Connect-AzAccount

# Reemplace la siguiente dirección URL por una URL de repositorio de GitHub pública
$gitrepo="https://github.com/Azure-Samples/app-service-web-dotnet-get-started.git"
$webappname="creahana-webapp1$(Get-Random)"
$location="east us"

# Crear un grupo de recursos.
New-AzResourceGroup -Name RG-Apps-Prod1 -Location $location

# Cree un plan de App Service en el nivel Gratis.
New-AzAppServicePlan -Name $webappname -Location $location -ResourceGroupName RG-Apps-Prod1 -Tier Free

# Cree una aplicación web.
New-AzWebApp -Name $webappname -Location $location -AppServicePlan $webappname -ResourceGroupName RG-Apps-Prod1

# Configure la implementación de GitHub desde el repositorio de GitHub.
$PropertiesObject = @{
    repoUrl = "$gitrepo";
    branch = "master";
    isManualIntegration = "true";
}
Set-AzResource -Properties $PropertiesObject -ResourceGroupName RG-Apps-Prod1 -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $webappname/web -ApiVersion 2015-08-01 -Force

# Eliminar recursos creados
Remove-AzResourceGroup -Name RG-Apps-Prod1 -Force