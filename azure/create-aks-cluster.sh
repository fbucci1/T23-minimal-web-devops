cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++++ Creando resource group${NC}\n"
az group create --name myResourceGroup --location eastus

az aks create -g myResourceGroup -n myAKSCluster --enable-managed-identity --node-count 1 --generate-ssh-keys --node-vm-size standard_a2_v2

az aks get-credentials --resource-group myResourceGroup --name myAKSCluster

kubectl get nodes

printf "${TITLE}++ Vinculando AKS con ACR. ACR debe haberse creado primero${NC}\n"
az aks update -n myAKSCluster -g myResourceGroup --attach-acr t23myrepotesis

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
