cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf "${TITLE}++ AKS Clusters${NC}\n"
az aks list

printf "${TITLE}++ VM Instances${NC}\n"
az vm list

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
