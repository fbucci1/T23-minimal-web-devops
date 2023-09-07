cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++ Delete AKS Cluster${NC}\n"
az aks delete --resource-group myResourceGroup --name myAKSCluster --yes

az group delete --name myResourceGroup --yes

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
