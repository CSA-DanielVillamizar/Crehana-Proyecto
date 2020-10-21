# Conectar
Connect-AzAccount
# Conocer los sustantivos, los verbos y los módulos de Azure PowerShell disponibles le ayuda a encontrar comandos con el cmdlet Get-Command.
Get-Command -Verb Get -Noun AzVM* -Module Az.Compute
# Crear grupo de recursos
New-AzResourceGroup -Name Crehana-RG-01 -Location eastus
# Instanciar credenciales para maquina virtual
$cred = Get-Credential -Message "Introduzca un nombre de usuario y una contraseña para la máquina virtual."
# Create a máquina virtual: ejemplo 1

$vmParams = @{
  ResourceGroupName = 'Crehana-RG-01'
  Name = 'SRV-WEB-01'
  Location = 'eastus'
  ImageName = 'Win2019Datacenter'
  PublicIpAddressName = 'WebPublicIp'
  Credential = $cred
  OpenPorts = 3389
}
$newVM1 = New-AzVM @vmParams

# Comprobar resultados
$newVM1

# Obtener información de VM con consultas

$newVM1.OSProfile | Select-Object ComputerName,AdminUserName

# Obtener información de la configuración de red

$newVM1 | Get-AzNetworkInterface |
  Select-Object -ExpandProperty IpConfigurations |
    Select-Object Name,PrivateIpAddress

# Verificar que la maquina este encendida para conectarnos via RDP
$publicIp = Get-AzPublicIpAddress -Name webPublicIp -ResourceGroupName Crehana-RG-01

$publicIp | Select-Object Name,IpAddress,@{label='FQDN';expression={$_.DnsSettings.Fqdn}}

# Conectar via RDP
mstsc.exe /v <PUBLIC_IP_ADDRESS>

# Crear unas segunda VM sobre la misma subred

$vm2Params = @{
  ResourceGroupName = 'Crehana-RG-01'
  Name = 'SRV-WEB-02'
  ImageName = 'Win2016Datacenter'
  VirtualNetworkName = 'SRV-WEB-01'
  SubnetName = 'SRV-WEB-01'
  PublicIpAddressName = 'WebPublicIp2'
  Credential = $cred
  OpenPorts = 3389
}
$newVM2 = New-AzVM @vm2Params

$newVM2

# Conectar via RDP
mstsc.exe /v $newVM2.FullyQualifiedDomainName

# Eliminar recursos
$job = Remove-AzResourceGroup -Name Crehana-RG-01 -Force -AsJob
$job