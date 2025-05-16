@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param appServicePlanName string = '' // Set in main.parameters.json
param backendServiceName string = '' // Set in main.parameters.json
param appServiceSkuName string // Set in main.parameters.json

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { environment: environmentName }

module appServicePlan '../../modules/appServicePlan.bicep' = {
  name: 'appserviceplan'
  params: {
    name: '${appServicePlanName}${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: appServiceSkuName
      capacity: 1
    }
    kind: 'linux'
  }
}

module backend '../../modules/appService.bicep' = {
  name: 'web'
  params: {
    name: '${backendServiceName}${resourceToken}'
    location: location
    tags: tags
    appServicePlanId: appServicePlan.outputs.id
    runtimeName: 'python'
    runtimeVersion: '3.13'
    appCommandLine: 'gunicorn -w 2 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000 main:app'
    scmDoBuildDuringDeployment: true
    managedIdentity: true
  }
}
