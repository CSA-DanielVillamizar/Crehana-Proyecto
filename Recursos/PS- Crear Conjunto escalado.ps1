<# Definición
El conjunto de escalado de máquinas virtuales le permite implementar y administrar 
un conjunto de máquinas virtuales de escalabilidad automática. Puede escalar el número 
de máquinas virtuales del conjunto de escalado manualmente o definir reglas de escalado 
automático según el uso de recursos tales como la CPU, la demanda de memoria o el tráfico 
de red. Un equilibrador de carga de Azure distribuirá el tráfico a las instancias de 
máquina virtual del conjunto de escalado. 
#>

# Crear RG
New-AzResourceGroup -ResourceGroupName "Creahana-rg-Scaleset" -Location "EastUS"

# Crear conjunto de escalado de máquinas virtuales 

New-AzVmss `
  -ResourceGroupName "Creahana-rg-Scaleset" `
  -Location "EastUS" `
  -VMScaleSetName "ScaleSet-Prod" `
  -VirtualNetworkName "VM-Vnet-Prod" `
  -SubnetName "VM-Subnet-FrontEnd" `
  -PublicIpAddressName "VM-PublicIPAddress" `
  -LoadBalancerName "VM-SS-LoadBalancer" `
  -UpgradePolicyMode "Automatic"


# Crear aplicación web prueba

# Definir el script para que se ejecute la extensión de script personalizado
$publicSettings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

# Get information about the scale set
$vmss = Get-AzVmss `
            -ResourceGroupName "Creahana-rg-Scaleset" `
            -VMScaleSetName "ScaleSet-Prod"

# Use Custom Script Extension para instalar IIS y configurar el sitio web básico
Add-AzVmssExtension -VirtualMachineScaleSet $vmss `
    -Name "customScript" `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.8 `
    -Setting $publicSettings

# Actualice el conjunto de escalado y aplique la extensión de script personalizado a las instancias de máquina virtual
Update-AzVmss `
    -ResourceGroupName "Creahana-rg-Scaleset" `
    -Name "ScaleSet-Prod" `
    -VirtualMachineScaleSet $vmss

# Permitir tráfico a la aplicación

# Obtener información sobre el conjunto de escalado
$vmss = Get-AzVmss `
            -ResourceGroupName "Creahana-rg-Scaleset" `
            -VMScaleSetName "ScaleSet-Prod"

#Crear una regla para permitir el tráfico a través del puerto 80
$nsgFrontendRule = New-AzNetworkSecurityRuleConfig `
  -Name FrontendNSGRule `
  -Protocol Tcp `
  -Direction Inbound `
  -Priority 200 `
  -SourceAddressPrefix * `
  -SourcePortRange * `
  -DestinationAddressPrefix * `
  -DestinationPortRange 80 `
  -Access Allow

#Cree un grupo de seguridad de red y asócielo a la regla
$nsgFrontend = New-AzNetworkSecurityGroup `
  -ResourceGroupName  "Creahana-rg-Scaleset" `
  -Location EastUS `
  -Name FrontendNSG `
  -SecurityRules $nsgFrontendRule

$vnet = Get-AzVirtualNetwork `
  -ResourceGroupName "Creahana-rg-Scaleset" `
  -Name VM-Vnet-Prod

$frontendSubnet = $vnet.Subnets[0]

$frontendSubnetConfig = Set-AzVirtualNetworkSubnetConfig `
  -VirtualNetwork $vnet `
  -Name VM-Subnet-FrontEnd `
  -AddressPrefix $frontendSubnet.AddressPrefix `
  -NetworkSecurityGroup $nsgFrontend

Set-AzVirtualNetwork -VirtualNetwork $vnet

# Actualice el conjunto de escalado y aplique la extensión de script personalizado a las instancias de máquina virtual
Update-AzVmss `
    -ResourceGroupName "Creahana-rg-Scaleset" `
    -Name "ScaleSet-Prod" `
    -VirtualMachineScaleSet $vmss