<# Definición

Azure Virtual Machines (VM) es uno de los diversos tipos de recursos informáticos a petición
y escalables que ofrece Azure. Por lo general, elegirá una máquina virtual cuando necesite 
más control sobre su entorno informático del que ofrecen las otras opciones. 

Una máquina virtual de Azure le ofrece la flexibilidad de la virtualización sin necesidad de adquirir 
y mantener el hardware físico que la ejecuta. Sin embargo, aún necesita mantener la máquina virtual 
con tareas como configurar, aplicar revisiones e instalar el software que se ejecuta en ella.

Las máquinas virtuales de Azure se pueden usar de diversas maneras. Ejemplos:

Desarrollo y pruebas: las máquinas virtuales de Azure ofrecen una manera rápida y sencilla de crear un 
equipo con configuraciones específicas necesarias para codificar y probar una aplicación.

Aplicaciones en la nube: como la demanda de la aplicación puede fluctuar, tendría sentido desde 
el punto de vista económico ejecutarla en una máquina virtual en Azure. Paga por las máquinas 
virtuales adicionales cuando las necesite y las desactiva cuando ya no sean necesarias.

Centro de datos ampliado: las máquinas virtuales de una red virtual de Azure se pueden conectar 
fácilmente a la red de su organización.

#>

# Iniciar Sesión
Connect-AzAccount

# Variables para valores comunes
$resourceGroup = "Crehana-RG-VM"
$location = "eastus"
$vmName = "SRV-WEB-01"

# Crear objeto de usuario
$cred = Get-Credential -Message "Introduzca un nombre de usuario y una contraseña para la máquina virtual."

# Crear un grupo de recursos
New-AzResourceGroup -Name $resourceGroup -Location $location

# Crear una configuración de subred
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name Subnet-FE-Prod -AddressPrefix 172.0.1.0/24

# Crear una red virtual
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
  -Name vNET-Prod -AddressPrefix 172.0.0.0/16 -Subnet $subnetConfig

# Cree una dirección IP pública y especificar un nombre DNS
$pip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
  -Name "vmpublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4

# Cree una regla de grupo de seguridad de red de entrada para el puerto 3389
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name vmNetworkSecurityGroupRuleRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Crear un grupo de seguridad de red
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
  -Name vmNetworkSecurityGroup -SecurityRules $nsgRuleRDP

# Cree una tarjeta de red virtual y asóciese con la dirección IP pública y NSG
$nic = New-AzNetworkInterface -Name VMNic -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# Crear una configuración de máquina virtual
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_A2_v2 | `
Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | `
Add-AzVMNetworkInterface -Id $nic.Id

# Crear una máquina virtual
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig

# Eliminar recursos creados
Remove-AzResourceGroup -Name Crehana-RG-VM -Force