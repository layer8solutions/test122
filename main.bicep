targetScope = 'subscription'

param rgName string 

param vnetName string = 'DemoVnetName'

param addressPrefixes array = [
  '10.10.8.0/21'
]

param location string = 'westeurope'

param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '10.10.8.0/24'
  }
  {
    name: 'subnet2'
    addressPrefix: '10.10.9.0/24'
 
  }
]

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}



module virtualNetwork 'packages/virtual-networks/main.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'virtualNetwork'
  params: {
    name: vnetName
    location: location
    addressPrefixes: addressPrefixes
    subnets: [
      {
        name: subnets[0].name
        addressPrefix: subnets[0].addressPrefix
      }
      {
        name: subnets[1].name
        addressPrefix: subnets[1].addressPrefix
      }
    ]
  }
}


module networkSecurityGroup 'packages/network-security-groups/main.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'networkSecurityGroup'
  params: {
    name: 'myNSG'
    securityRules: [
      {
        name: 'denyAnyAny'
        properties: {
          priority: 300
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

module routeTable 'packages/route-tables/main.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'routeTable'
  params: {
    name: 'myRouteTable'
    routes: [
      {
        name: 'routeToInternet'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.100.0.54'
          hasBgpOverride: false
        }
      }
    ]
  }
}
