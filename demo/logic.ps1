# General Resource Group Variables
$ENV="demo"
$RND_NUMBER=Get-Random -Minimum 10000 -Maximum 99999
$LOCATION="eastus"

# Specific Resource Group Variables
$PROJECT="logic"
$TAGS = @(
  "env=$ENV"
  "project=$PROJECT"
  "status=s2d"
)
$RESOURCEGROUP = "rg-$ENV-$PROJECT-$RND_NUMBER"
az group create --name $RESOURCEGROUP --location $LOCATION --tags $TAGS --query name -o tsv

# AZURE lOGIC APP
az logic workflow create --name $PROJECT-$RND_NUMBER --resource-group $RESOURCEGROUP --location $LOCATION --definition logicAppDefinition.json --query name -o tsv

 # Test Logic App
 # If this fails install Azure PowerShell
 # Install-Module -Name Az.LogicApp -Repository PSGallery -Scope CurrentUser -Force
$URI = (Get-AzLogicAppTriggerCallbackUrl -ResourceGroupName $RESOURCEGROUP -Name $PROJECT-$RND_NUMBER -TriggerName "manual").Value
$body = '{}'
Invoke-RestMethod -Method Post -Uri $URI -ContentType "application/json" -Body $body
