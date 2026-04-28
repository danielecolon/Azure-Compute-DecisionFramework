$ENV = "demo"
$PROJECT = "vmss"
$RND_NUMBER = Get-Random -Minimum 10000 -Maximum 99999
$LOCATION = "eastus"

#if you don't have a ssh public key
#ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\id_rsa"

$SSH_PUBLIC_KEY = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub" -Raw

az deployment sub create `
  --name deploy-$PROJECT-$RND_NUMBER `
  --location $LOCATION `
  --template-file main.bicep `
  --query properties.outputs `
  -o jsonc `
  --parameters `
    env=$ENV `
    project=$PROJECT `
    rndNumber=$RND_NUMBER `
    location=$LOCATION `
    sshPublicKey="$SSH_PUBLIC_KEY"


