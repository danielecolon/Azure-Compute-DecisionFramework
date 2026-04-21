# General Resource Group Variables
$ENV="demo"
$RND_NUMBER=Get-Random -Minimum 10000 -Maximum 99999
$LOCATION="eastus"

# Specific Resource Group Variables
$PROJECT="aca"
$TAGS = @(
  "env=$ENV"
  "project=$PROJECT"
  "status=s2d"
)
$RESOURCEGROUP = "rg-$ENV-$PROJECT-$RND_NUMBER"
az group create --name $RESOURCEGROUP --location $LOCATION --tags $TAGS --query name -o tsv

# AZURE ACI
$IMAGE="mcr.microsoft.com/oss/nginx/nginx:1.9.15-alpine"
az containerapp env create --name env-$PROJECT-$RND_NUMBER --resource-group $RESOURCEGROUP --location $LOCATION
az containerapp create  --name $PROJECT-$RND_NUMBER --resource-group $RESOURCEGROUP --environment env-$PROJECT-$RND_NUMBER --image $IMAGE --target-port 80 --ingress 'external' --query properties.configuration.ingress.fqdn -o tsv
