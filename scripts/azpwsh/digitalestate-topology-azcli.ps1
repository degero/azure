pip install azure-identity azure-mgmt-resource azure-mgmt-network

az login

Read-Host -Prompt "Enter your subscription ID" -OutVariable subscriptionId
Read-Host -Prompt "Enter your resource group name or leave blank for all" -OutVariable resourceGroupName

python ./digitalestate-topology.py -s $subscriptionId -g $resourceGroupName