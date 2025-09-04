# Azure DevOps Self Hosted agent docker image

This helps speed up setting up your ADO agent docker (windows or linux) container as there is no repo for the code contained in the MSLearn article listed below in "More information". Alpine was chosen for Linux due to it's smaller footprint.

## Get Started 

Get your organisation url https://dev.azure.com/<org name>

Create a PAT with scope Agent pools (read, manage) https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate

Create a new agent pool if you wish to have agent in separate pool from default pool  https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues

## Run agent

### Linux docker

- docker build --tag "azp-agent:linux" --file "./azp-agent-linux.dockerfile" .
- Edit dockerstart.sh with AZP_URL, AZP_TOKEN from your url and PAT and AZP_POOL if you have a new pool
- Run ./dockerstart.sh (this will run as interactive so you can terminate)

### Windows docker

- docker build --tag "azp-agent:windows" --file "./azp-agent-windows.dockerfile" .
- Edit dockerstart.ps1 with AZP_URL, AZP_TOKEN from your url and PAT and AZP_POOL if you have a new pool
- Run ./dockerstart.ps1  (this will run as interactive so you can terminate)

## Run pipelines

- Run your pipeline as normal, if you have a new pool [switch your pipeline to this pool](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues?view=azure-devops&tabs=yaml%2Cbrowser#designate-a-pool-in-your-pipeline)


## More information

https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker

This article replaces the retired github repo for [vsts-agent-docker](https://github.com/microsoft/vsts-agent-docker/tree/master) used in the [official ADO pipeline agent image](https://hub.docker.com/r/microsoft/azure-pipelines-vsts-agent)