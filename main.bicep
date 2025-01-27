targetScope = 'subscription'
module network 'packages/ipm-network/main.bicep' = {
  scope: subscription()
  name: 'DeployNetwork'
  params: {
    rgName: 'rg-network-001'
  }
}
