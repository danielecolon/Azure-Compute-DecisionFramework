targetScope = 'subscription'

param env string = 'demo'
param project string = 'vmss'
param rndNumber string
param location string = 'eastus'

@description('SSH public key')
param sshPublicKey string

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

module vmss './vmss.bicep' = {
  name: 'deploy-vmss-${rndNumber}'
  scope: rg
  params: {
    project: project
    rndNumber: rndNumber
    location: location
    sshPublicKey: sshPublicKey
  }
}

output resourceGroupName string = rg.name
output vmssName string = vmss.outputs.vmssName
output loadBalancerName string = vmss.outputs.loadBalancerName
output publicIpName string = vmss.outputs.publicIpName
output publicIpAddress string = vmss.outputs.publicIpAddress
output websiteUrl string = vmss.outputs.websiteUrl
