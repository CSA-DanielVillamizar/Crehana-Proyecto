# Crear Recurso
az group create --location eastus --name Crehana-RG
# Crear Maquina
az vm create -n SRV-LINUX-01 -g Crehana-RG --image UbuntuLTS --generate-ssh-keys
# Conexión SSH con la máquina virtual Linux
ssh username@ipaddress
# Cerrar la sesión de SSH
exit
# Eliminar el grupo de recursos y cualquier recurso dentro del mismo.
az group delete -n Crehana-RG
