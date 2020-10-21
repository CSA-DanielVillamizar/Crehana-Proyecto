# Crear una red para el ejemplo de script de aplicaciones de varios niveles

# Variables para valores comunes
$rgName='Crehana-RG-02'
$location='eastus2'

# Crear objeto de usuario
$cred = Get-Credential -Message "Introduzca un nombre de usuario y una contraseña para la máquina virtual."

# Cree un grupo de recursos.
New-AzResourceGroup -Name $rgName -Location $location

# Crear una red virtual con una subred front-end y una subred back-end.
$fesubnet = New-AzVirtualNetworkSubnetConfig -Name 'Subnet-FrontEnd' -AddressPrefix '10.0.1.0/24'
$besubnet = New-AzVirtualNetworkSubnetConfig -Name 'Subnet-BackEnd' -AddressPrefix '10.0.2.0/24'
$vnet = New-AzVirtualNetwork -ResourceGroupName $rgName -Name 'Vnet-App-Prod' -AddressPrefix '10.0.0.0/16' `
  -Location $location -Subnet $fesubnet, $besubnet

# Crear una regla de NSG para permitir el tráfico HTTP desde Internet a la subred front-end.
$rule1 = New-AzNetworkSecurityRuleConfig -Name 'Allow-HTTP-All' -Description 'Allow HTTP' `
  -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
  -SourceAddressPrefix Internet -SourcePortRange * `
  -DestinationAddressPrefix * -DestinationPortRange 80

# Crear una regla de NSG para permitir el tráfico RDP desde Internet a la subred front-end.
$rule2 = New-AzNetworkSecurityRuleConfig -Name 'Allow-RDP-All' -Description "Allow RDP" `
  -Access Allow -Protocol Tcp -Direction Inbound -Priority 200 `
  -SourceAddressPrefix Internet -SourcePortRange * `
  -DestinationAddressPrefix * -DestinationPortRange 3389


# Crear un grupo de seguridad de red para la subred front-end.
$nsgfe = New-AzNetworkSecurityGroup -ResourceGroupName $RgName -Location $location `
  -Name 'Nsg-FrontEnd' -SecurityRules $rule1,$rule2

# Asociar el NSG front-end a la subred front-end.
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'Subnet-FrontEnd' `
  -AddressPrefix '10.0.1.0/24' -NetworkSecurityGroup $nsgfe

# Crear una regla de NSG para permitir el tráfico SQL desde la subred front-end a la subred back-end.
$rule1 = New-AzNetworkSecurityRuleConfig -Name 'Allow-SQL-FrontEnd' -Description "Allow SQL" `
  -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
  -SourceAddressPrefix '10.0.1.0/24' -SourcePortRange * `
  -DestinationAddressPrefix * -DestinationPortRange 1433

# Crear una regla de NSG para permitir el tráfico RDP desde Internet a la subred back-end.
$rule2 = New-AzNetworkSecurityRuleConfig -Name 'Allow-RDP-All' -Description "Allow RDP" `
  -Access Allow -Protocol Tcp -Direction Inbound -Priority 200 `
  -SourceAddressPrefix Internet -SourcePortRange * `
  -DestinationAddressPrefix * -DestinationPortRange 3389

# Crear un grupo de seguridad de red para la subred back-end.
$nsgbe = New-AzNetworkSecurityGroup -ResourceGroupName $RgName -Location $location `
  -Name "Nsg-BackEnd" -SecurityRules $rule1,$rule2

# Asociar el NSG back-end a la subred back-end
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'Subnet-BackEnd' `
  -AddressPrefix '10.0.2.0/24' -NetworkSecurityGroup $nsgbe

# Crear una dirección IP pública para la máquina virtual del servidor web.
$publicipvm1 = New-AzPublicIpAddress -ResourceGroupName $rgName -Name 'PublicIp-Web-01' `
  -location $location -AllocationMethod Dynamic

# Crear una NIC para la máquina virtual del servidor web.
$nicVMweb = New-AzNetworkInterface -ResourceGroupName $rgName -Location $location `
  -Name 'Nic-Web-01' -PublicIpAddress $publicipvm1 -NetworkSecurityGroup $nsgfe -Subnet $vnet.Subnets[0]

# Crear una máquina virtual de servidor web en la subred front-end
$vmConfig = New-AzVMConfig -VMName 'Vm-Web-01' -VMSize 'Standard_DS2' | `
  Set-AzVMOperatingSystem -Windows -ComputerName 'Vm-Web-01' -Credential $cred | `
  Set-AzVMSourceImage -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' `
  -Skus '2016-Datacenter' -Version latest | Add-AzVMNetworkInterface -Id $nicVMweb.Id

$vmweb = New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig

# Create a public IP address for the SQL VM.
$publicipvm2 = New-AzPublicIpAddress -ResourceGroupName $rgName -Name PublicIP-Sql-01 `
  -location $location -AllocationMethod Dynamic

# Crear una NIC para la máquina virtual SQL.
$nicVMsql = New-AzNetworkInterface -ResourceGroupName $rgName -Location $location `
  -Name 'Nic-Sql-01' -PublicIpAddress $publicipvm2 -NetworkSecurityGroup $nsgbe -Subnet $vnet.Subnets[1] 

# Crear una máquina virtual SQL en la subred back-end.
$vmConfig = New-AzVMConfig -VMName 'Vm-Sql-01' -VMSize 'Standard_DS2' | `
  Set-AzVMOperatingSystem -Windows -ComputerName 'Vm-Sql-01' -Credential $cred | `
  Set-AzVMSourceImage -PublisherName 'MicrosoftSQLServer' -Offer 'SQL2016-WS2016' `
  -Skus 'Web' -Version latest | Add-AzVMNetworkInterface -Id $nicVMsql.Id

$vmsql = New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig

# Crear una regla de NSG para bloquear todo el tráfico saliente de la subred back-end a Internet (debe realizarse después de la creación de la máquina virtual)
$rule3 = New-AzNetworkSecurityRuleConfig -Name 'Deny-Internet-All' -Description "Deny Internet All" `
  -Access Deny -Protocol Tcp -Direction Outbound -Priority 300 `
  -SourceAddressPrefix * -SourcePortRange * `
  -DestinationAddressPrefix Internet -DestinationPortRange *

# Agregar regla NSG a Back-end NSG
$nsgbe.SecurityRules.add($rule3)

Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsgbe


# Eliminar recursos
#Remove-AzResourceGroup -Name Crehana-RG-02 -Force