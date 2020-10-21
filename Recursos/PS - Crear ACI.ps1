<# Definición
Cuando los usuarios piensan en la virtualización, a menudo les viene a la mente las máquinas virtuales 
(VM). En realidad, la virtualización puede tomar muchas formas y los contenedores son una de ellas. 

¿Cuál es la diferencia entre las máquinas virtuales y los contenedores?

A grandes rasgos, las máquinas virtuales virtualizan el hardware subyacente para que se puedan ejecutar
varias instancias de sistemas operativos (SO) en el hardware. C

Un contenedor virtualiza el sistema operativo y hace que la aplicación en contenedor perciba 
que tiene el sistema operativo (incluidas la CPU, la memoria, el almacenamiento de archivos y las 
conexiones de red) todo para ella sola. 

Esto permite que los contenedores sean mucho más eficientes y ligeros.

ACI

Azure Container Instances resulta útil para escenarios que pueden funcionar en contenedores aislados, 
lo que incluye aplicaciones simples, automatización de tareas y trabajos de compilación. 

Inicio rápido: inicie los contenedores en cuestión de segundos.
Facturación por segundo: solo se generan gastos mientras se ejecuta el contenedor.
Seguridad de nivel de hipervisor: la aplicación se aísla completamente, como si estuviera en una máquina
virtual.
Tamaños personalizados: especifique los valores exactos de núcleos de CPU y memoria.
Almacenamiento persistente: monte recursos compartidos de Azure Files directamente en un contenedor 
para recuperar y conservar el estado.
Linux y Windows: programe contenedores Windows y Linux con la misma API.

En aquellos escenarios donde se necesita una orquestación completa de contenedores, lo que incluye 
la detección de servicios en varios contenedores, el escalado automático y las actualizaciones de 
aplicaciones coordinadas, se recomienda Azure Kubernetes Service (AKS).

Azure Kubernetes Service (AKSAzure Kubernetes Service (AKS) simplifica la implementación de los 
clústeres de Kubernetes administrados en Azure. AKS reduce la complejidad y la sobrecarga operativa 
de la administración de Kubernetes al descargar gran parte de esa responsabilidad en Azure. 
Como servicio hospedado de Kubernetes, Azure maneja tareas críticas como la supervisión del estado y 
el mantenimiento para usted. Azure administra los maestros de Kubernetes. Usted solo administra y 
mantiene los nodos del agente.


#>

New-AzResourceGroup -Name ACI-RG-01 -Location "eastus" 
New-AzResourceGroupDeployment -ResourceGroupName ACI-RG -TemplateUri https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/aci-linuxcontainer-public-ip/azuredeploy.json


