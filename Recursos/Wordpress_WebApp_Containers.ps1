# Iniciar sesion
az login

# crear un grupo de recursos para mantener todo en esta demostración
$resourceGroup = "wordpressappservice"
$location = "westeurope"
az group create -l $location -n $resourceGroup

# Cuando creamos el plan de servicio de aplicaciones, tendremos que especificar la marca --is-linux a medida que planeamos usar una imagen de contenedor de Linux.
# crear un plan de servicio de aplicaciones para hospedar nuestra aplicación web
$planName="wordpressappservice"
az appservice plan create -n $planName -g $resourceGroup `
                          -l $location --is-linux --sku S1

# A continuación, necesitamos crear un servidor MySQL
# Necesitamos un nombre único para el servidor
$mysqlServerName = "mysql-crehana"
$adminUser = "wpadmin"
$adminPassword = "J9!3EklqIl1-LS,am3f"

az mysql server create -g $resourceGroup -n $mysqlServerName `
            --admin-user $adminUser --admin-password "$adminPassword" `
            -l $location `
            --ssl-enforcement Disabled `
            --sku-name GP_Gen5_2 --version 5.7

# Y también tendremos que abrir una regla de firewall para permitir que nuestra aplicación web hable con el servidor MySQL. El enfoque más sencillo es usar la dirección especial 0.0.0.0 para permitir todo el tráfico interno de Azure, pero una mejor solución es obtener las direcciones IP salientes de nuestra aplicación web y crear explícitamente una regla para cada una.

# abrir el firewall (use 0.0.0.0 para permitir todo el tráfico de Azure por ahora)
az mysql server firewall-rule create -g $resourceGroup `
    --server $mysqlServerName --name AllowAppService `
    --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# Crear una aplicación web a partir de un contenedor
$appName="wordpress-crehana"
az webapp create -n $appName -g $resourceGroup `
                 --plan $planName -i "wordpress"

<# Configurar las variables de entorno
La configuración de variables de entorno para nuestro contenedor se realiza estableciendo las aplicaciones web "Configuración de la aplicación", que aparecerán como variables de entorno dentro del contenedor. La imagen del contenedor de WordPress espera tres variables de entorno para el nombre de host de la base de datos, el nombre de usuario y la contraseña
#>

# get hold of the wordpress DB host name
$wordpressDbHost = (az mysql server show -g $resourceGroup -n $mysqlServerName `
                   --query "fullyQualifiedDomainName" -o tsv)

# configurar la configuración de la aplicación web (variables de entorno de contenedor)
az webapp config appsettings set `
    -n $appName -g $resourceGroup --settings `
    WORDPRESS_DB_HOST=$wordpressDbHost `
    WORDPRESS_DB_USER="$adminUser@$mysqlServerName" `
    WORDPRESS_DB_PASSWORD="$adminPassword"

# Podemos averiguar el nombre de dominio de nuestro sitio de WordPress con el comando az webapp show como este:

$site = az webapp show -n $appName -g $resourceGroup `
                       --query "defaultHostName" -o tsv
Start-Process https://$site