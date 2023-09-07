cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++ Delete ECR repository${NC}\n"
aws ecr delete-repository --repository-name tesis-repo --force

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
