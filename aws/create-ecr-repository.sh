cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++ Create ECR - Docker image registry${NC}\n"
aws ecr create-repository --repository-name tesis-repo --image-scanning-configuration scanOnPush=false --region us-east-1 --tags Key=group,Value=tesis

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
