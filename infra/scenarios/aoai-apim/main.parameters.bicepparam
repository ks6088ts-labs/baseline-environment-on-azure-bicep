using 'main.bicep'

param openAiDeployments = [
  {
    name: 'text-embedding-ada-002'
    version: '2'
    capacity: 30
  }
  {
    name: 'gpt-35-turbo'
    version: '0613'
    capacity: 30
  }
]

param tags = {
  scenario: 'aoai-apim'
}
