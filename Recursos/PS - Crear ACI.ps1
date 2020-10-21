<# Definición
Cuando los usuarios piensan en la virtualización, a menudo les viene a la mente las máquinas virtuales 
(VM). En realidad, la virtualización puede tomar muchas formas y los contenedores son una de ellas. 
¿Cuál es la diferencia entre las máquinas virtuales y los contenedores?

A grandes rasgos, las máquinas virtuales virtualizan el hardware subyacente para que se puedan ejecutar
varias instancias de sistemas operativos (SO) en el hardware. Cada máquina virtual ejecuta un sistema 
operativo y tiene acceso a recursos virtualizados que representan el hardware subyacente.

Las máquinas virtuales tienen muchas ventajas. Entre ellas se incluyen la capacidad de ejecutar 
diferentes sistemas operativos en el mismo servidor, el uso más eficaz y rentable de los recursos 
físicos y el aprovisionamiento de servidores más rápido. Por otra parte, cada máquina virtual contiene 
una imagen de sistema operativo, bibliotecas, aplicaciones, etc., por lo que puede ser bastante grande.

Un contenedor virtualiza el sistema operativo subyacente y hace que la aplicación en contenedor perciba 
que tiene el sistema operativo (incluidas la CPU, la memoria, el almacenamiento de archivos y las 
conexiones de red) todo para ella sola. Dado que se abstraen las diferencias en el sistema operativo y
la infraestructura subyacentes, siempre que la imagen base sea coherente, el contenedor se puede 
implementar y ejecutar en cualquier lugar. Para los desarrolladores, esto es sumamente interesante.

Puesto que los contenedores comparten el sistema operativo host, no necesitan arrancar un sistema 
operativo ni cargar bibliotecas. Esto permite que los contenedores sean mucho más eficientes y ligeros.
Las aplicaciones en contenedor se pueden iniciar en segundos y pueden caber muchas más instancias de la 
aplicación en la máquina en comparación con un escenario de máquina virtual. El enfoque de un sistema 
operativo compartido tiene la ventaja adicional de reducir la sobrecarga en términos de mantenimiento, 
como la aplicación de revisiones y actualizaciones.

ACI

Azure Container Instances resulta útil para escenarios que pueden funcionar en contenedores aislados, lo que incluye aplicaciones simples, automatización de tareas y trabajos de compilación. Estas son algunas de las ventajas:

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

New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> #use this command when you need to create a new resource group for your deployment
New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateUri https://raw.githubusercontent.com/CSA-DanielVillamizar/Crehana-Proyecto/master/Recursos/aci-linuxcontainer-public-ip/azuredeploy.json


