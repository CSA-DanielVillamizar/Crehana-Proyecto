<# Definición
El conjunto de escalado de máquinas virtuales le permite implementar y administrar 
un conjunto de máquinas virtuales de escalabilidad automática. Puede escalar el número 
de máquinas virtuales del conjunto de escalado manualmente o definir reglas de escalado 
automático según el uso de recursos tales como la CPU, la demanda de memoria o el tráfico 
de red. Un equilibrador de carga de Azure distribuirá el tráfico a las instancias de 
máquina virtual del conjunto de escalado. 
#>
# Iniciar Sesión
Connect-AzAccount

# Crear RG
New-AzResourceGroup -ResourceGroupName "Creahana-rg-Scaleset2" -Location "EastUS"

# Crear conjunto de escalado de máquinas virtuales 

New-AzVmss `
  -ResourceGroupName "Creahana-rg-Scaleset2" `
  -Location "EastUS" `
  -VMScaleSetName "ScaleSet-Prod2" `
  -VirtualNetworkName "VM-Vnet-Prod2" `
  -SubnetName "VM-Subnet-FrontEnd2" `
  -PublicIpAddressName "VM-PublicIPAddress2" `
  -LoadBalancerName "VM-SS-LoadBalancer2" `
  -UpgradePolicyMode "Automatic"


# Crear aplicación web prueba

# Definir el script para que se ejecute la extensión de script personalizado
$publicSettings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

# Get information about the scale set
$vmss = Get-AzVmss `
            -ResourceGroupName "Creahana-rg-Scaleset2" `
            -VMScaleSetName "ScaleSet-Prod2"

# Use Custom Script Extension para instalar IIS y configurar el sitio web básico
Add-AzVmssExtension -VirtualMachineScaleSet $vmss `
    -Name "customScript" `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.8 `
    -Setting $publicSettings

# Actualice el conjunto de escalado y aplique la extensión de script personalizado a las instancias de máquina virtual
Update-AzVmss `
    -ResourceGroupName "Creahana-rg-Scaleset2" `
    -Name "ScaleSet-Prod2" `
    -VirtualMachineScaleSet $vmss

# Permitir tráfico a la aplicación

# Obtener información sobre el conjunto de escalado
$vmss = Get-AzVmss `
            -ResourceGroupName "Creahana-rg-Scaleset2" `
            -VMScaleSetName "ScaleSet-Prod2"

#Crear una regla para permitir el tráfico a través del puerto 80
$nsgFrontendRule = New-AzNetworkSecurityRuleConfig `
  -Name FrontendNSGRule2 `
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
  -ResourceGroupName  "Creahana-rg-Scaleset2" `
  -Location EastUS `
  -Name FrontendNSG2 `
  -SecurityRules $nsgFrontendRule

$vnet = Get-AzVirtualNetwork `
  -ResourceGroupName "Creahana-rg-Scaleset2" `
  -Name VM-Vnet-Prod2

$frontendSubnet = $vnet.Subnets[0]

$frontendSubnetConfig = Set-AzVirtualNetworkSubnetConfig `
  -VirtualNetwork $vnet `
  -Name VM-Subnet-FrontEnd2 `
  -AddressPrefix $frontendSubnet.AddressPrefix `
  -NetworkSecurityGroup $nsgFrontend

Set-AzVirtualNetwork -VirtualNetwork $vnet

# Actualice el conjunto de escalado y aplique la extensión de script personalizado a las instancias de máquina virtual
Update-AzVmss `
    -ResourceGroupName "Creahana-rg-Scaleset2" `
    -Name "ScaleSet-Prod2" `
    -VirtualMachineScaleSet $vmss


# Eliminar recursos creados
Remove-AzResourceGroup -Name Creahana-rg-Scaleset2 -Force