#!/bin/bash
# args:
# vmName
# vmRG
# action - start/stop/restart/deallocate

if [ -z $1 ]
then
    read -p "VM Name: " vmName
else
    vmName = $1
fi

if [ -z $2 ]
then
    read -p "VM Resource Group: " vmRG
else
    vmRG = $2
fi

if [ -z $3 ]
then
    read -p "action[start/stop/restart/deallocate]: " action
else
    action = $3
fi

case "$action" in 
  start) 
    az vm start --resource-group $vmRG --name $vmName ;;
  stop)
    az vm deallocate --resource-group $vmRG --name $vmName ;;
  restart)
    az vm restart --resource-group $vmRG --name $vmName ;;
  deallocate)
    az vm deallocate --resource-group $vmRG --name $vmName ;;
  *)
    echo "Invalid action. Please use 'start', 'stop', 'restart', or 'deallocate'." ;;
esac