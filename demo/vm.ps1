# General Resource Group Variables
$ENV="demo"
$RND_NUMBER=Get-Random -Minimum 10000 -Maximum 99999
$LOCATION="eastus"

# Specific Resource Group Variables
$PROJECT="vm"
$TAGS = @(
  "env=$ENV"
  "project=$PROJECT"
  "status=s2d"
)
$RESOURCEGROUP = "rg-$ENV-$PROJECT-$RND_NUMBER"
az group create --name $RESOURCEGROUP --location $LOCATION --tags $TAGS --query name -o tsv

# VM Variables
$USERNAME = "azureuser"
$PUBLICIPSKU = "Standard"
$IMAGE = "canonical:ubuntu-24_04-lts:server:latest"
$SIZE = "Standard_D2s_v3"
# VM
az vm create --resource-group $RESOURCEGROUP --name $PROJECT-$RND_NUMBER --public-ip-sku $PUBLICIPSKU --size $SIZE --admin-username $USERNAME --public-ip-address-dns-name $PROJECT-$RND_NUMBER --image $IMAGE --generate-ssh-keys --custom-data cloud-init.txt

# Open port 80 for web traffic
az vm open-port --port 80 --resource-group $RESOURCEGROUP --name $PROJECT-$RND_NUMBER 

# # Get public IP
$IP = az vm show -d --resource-group $RESOURCEGROUP --name $PROJECT-$RND_NUMBER --query publicIps -o tsv
Write-Host "Web server available at: http://$IP"