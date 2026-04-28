$RND_NUMBER = Get-Random -Minimum 10000 -Maximum 99999

az deployment sub create `
  --location eastus `
  --template-file main.bicep `
  --parameters rndNumber=$RND_NUMBER `
  --query properties.outputs `
  -o jsonc