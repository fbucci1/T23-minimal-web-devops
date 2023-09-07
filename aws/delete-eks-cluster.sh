cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++ Delete EKS cluster${NC}\n"
echo ++ It takes about 12 minutes to finish
eksctl delete cluster --name Tesis

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
