targetScope = 'subscription'

param env string = 'demo'
param project string = 'aci'
param rndNumber string
param location string = 'eastus'

var resourceGroupName = 'rg-${env}-${project}-${rndNumber}'

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: {
    env: env
    project: project
    status: 's2d'
  }
}

module aci './aci-rg.bicep' = {
  name: 'deploy-aci-${rndNumber}'
  scope: rg
  params: {
    project: project
    rndNumber: rndNumber
    location: location
  }
}

output resourceGroupName string = rg.name
output fqdn string = aci.outputs.fqdn
