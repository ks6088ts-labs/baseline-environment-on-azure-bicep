using 'main.bicep'

// To get the values for the following parameters, you can use the following commands:
// $ step certificate fingerprint client1-authn-ID.pem
param eventGridClientThumbprint1 = 'your-event-grid-client-thumbprint1'

// To get the values for the following parameters, you can use the following commands:
// $ step certificate fingerprint client2-authn-ID.pem
param eventGridClientThumbprint2 = 'your-event-grid-client-thumbprint2'

// Feature flags
param eventHubEnabled = true

param tags = {
  scenario: 'event-grid-mqtt'
}
