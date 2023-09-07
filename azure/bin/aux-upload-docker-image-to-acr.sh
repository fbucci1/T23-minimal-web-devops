cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

echo ++ Get repository server hostname -- HARDCODED t23myrepotesis.azurecr.io
az acr list --resource-group myResourceGroup --query "[].{acrLoginServer:loginServer}" --output table

echo ++ Relate docker image with ACR repo URL
sudo docker tag t23-minimal-web-w-lanzador t23myrepotesis.azurecr.io/t23-minimal-web-w-lanzador

echo ++ Relate docker to Azure authentication
TOKEN=$(az acr login --name t23myrepotesis --expose-token --output tsv --query accessToken)
echo $TOKEN | docker login t23myrepotesis.azurecr.io --username 00000000-0000-0000-0000-000000000000 --password-stdin

echo ++ Push docker image to ACR
#OJO sin sudo!!
docker push t23myrepotesis.azurecr.io/t23-minimal-web-w-lanzador
    
echo ++ List images in ACR
az acr repository list --name t23myrepotesis --output table

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
