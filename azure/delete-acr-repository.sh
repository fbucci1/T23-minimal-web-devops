cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++ Delete ACR repository${NC}\n"
az acr repository delete --name t23myrepotesis --repository t23-minimal-web-w-lanzador --yes

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
