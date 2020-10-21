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