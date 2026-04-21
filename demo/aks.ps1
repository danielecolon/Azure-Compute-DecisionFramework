# General Resource Group Variables
$ENV="demo"
$RND_NUMBER=Get-Random -Minimum 10000 -Maximum 99999
$LOCATION="eastus"

# Specific Resource Group Variables
$PROJECT="aks"
$TAGS = @(
  "env=$ENV"
  "project=$PROJECT"
  "status=s2d"
)
$RESOURCEGROUP = "rg-$ENV-$PROJECT-$RND_NUMBER"
az group create --name $RESOURCEGROUP --location $LOCATION --tags $TAGS --query name -o tsv

# AZURE AKS
az aks create --name $PROJECT-$RND_NUMBER --resource-group $RESOURCEGROUP --node-count 1 --sku base
az aks get-credentials --name $PROJECT-$RND_NUMBER --resource-group $RESOURCEGROUP

# Deploy nginx
kubectl apply -f nginx-demo.yaml
kubectl get svc nginx-service --namespace $ENV