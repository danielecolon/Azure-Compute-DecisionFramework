# General Resource Group Variables
$ENV="demo"
$RND_NUMBER=Get-Random -Minimum 10000 -Maximum 99999
$LOCATION="eastus"

# Specific Resource Group Variables
$PROJECT="aci"
$TAGS = @(
  "env=$ENV"
  "project=$PROJECT"
  "status=s2d"
)
$RESOURCEGROUP = "rg-$ENV-$PROJECT-$RND_NUMBER"
az group create --name $RESOURCEGROUP --location $LOCATION --tags $TAGS --query name -o tsv

# AZURE ACI
$IMAGE="mcr.microsoft.com/oss/nginx/nginx:1.9.15-alpine"
$OSTYPE="Linux"
$CPU=1
$MEMORY=1
az container create --name $PROJECT-$RND_NUMBER --resource-group $RESOURCEGROUP --location $LOCATION --image $IMAGE --os-type $OSTYPE --cpu $CPU --memory $MEMORY --dns-name-label aci-$RND_NUMBER --ports 80 --query ipAddress.fqdn -o tsv