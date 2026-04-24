# General Resource Group Variables
$ENV="demo"
$RND_NUMBER=Get-Random -Minimum 10000 -Maximum 99999
$LOCATION="eastus"

# Specific Resource Group Variables
$PROJECT="vmss"
$TAGS = @(
  "env=$ENV"
  "project=$PROJECT"
  "status=s2d"
)
$RESOURCEGROUP = "rg-$ENV-$PROJECT-$RND_NUMBER"
az group create --name $RESOURCEGROUP --location $LOCATION --tags $TAGS --query name -o tsv

# VMMS Variables
$USERNAME = "azureuser"
$IMAGE = "canonical:ubuntu-24_04-lts:server:latest"
$VMSKU = "Standard_D2s_v3"
# VMSS
az vmss create --name $PROJECT-$RND_NUMBER --resource-group $RESOURCEGROUP  --location $LOCATION --image $IMAGE --admin-username $USERNAME --generate-ssh-keys --instance-count 2 --vm-sku $VMSKU --custom-data cloud-init.txt --load-balancer lb--$RND_NUMBER

# Open port 80 for web traffic
az network nsg rule create --name allow-HTTP --nsg-name "$($PROJECT)-$($RND_NUMBER)NSG"  --resource-group $RESOURCEGROUP --direction inbound --priority 1010 --destination-port-range 80

# Get public IP of Load Balancer
$IP = az network public-ip list --resource-group $RESOURCEGROUP --query "[0].ipAddress" -o tsv
Write-Host "Web server available at: http://$IP"