targetScope = 'resourceGroup'

param project string = 'aci'
param rndNumber string
param location string = 'eastus'

param image string = 'mcr.microsoft.com/oss/nginx/nginx:1.9.15-alpine'
param cpu int = 1
param memory int = 1

var containerGroupName = '${project}-${rndNumber}'
var dnsNameLabel = 'aci-${rndNumber}'

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: containerGroupName
  location: location
  properties: {
    osType: 'Linux'
    restartPolicy: 'Always'
    containers: [
      {
        name: containerGroupName
        properties: {
          image: image
          resources: {
            requests: {
              cpu: cpu
              memoryInGB: memory
            }
          }
          ports: [
            {
              port: 80
              protocol: 'TCP'
            }
          ]
        }
      }
    ]
    ipAddress: {
      type: 'Public'
      dnsNameLabel: dnsNameLabel
      ports: [
        {
          port: 80
          protocol: 'TCP'
        }
      ]
    }
  }
}

output fqdn string = containerGroup.properties.ipAddress.fqdn
