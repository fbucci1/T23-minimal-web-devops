cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++++ Creando resource group${NC}\n"
az group create --name myResourceGroup --location eastus

az acr create --resource-group myResourceGroup --name t23myrepotesis --sku Basic

az acr login --name t23myrepotesis

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
