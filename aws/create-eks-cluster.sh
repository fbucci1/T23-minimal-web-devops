cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}Creating EKS cluster and node group with 1 node t2.small${NC}\n"
echo ++ It takes about 17 minutes...
eksctl create cluster --name Tesis --region us-east-1 --node-type t2.small --nodes 1

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
