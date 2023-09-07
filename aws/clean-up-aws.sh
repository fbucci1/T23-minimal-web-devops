cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"


./delete-ecr-repository.sh

./delete-eks-cluster.sh

./list-resources.sh

sudo printf "${TITLE}Check aws console to ensure there are no more resources. Some links:${NC}\n"
echo + https://us-east-1.console.aws.amazon.com/ecr/home
echo + https://us-east-1.console.aws.amazon.com/eks/home
echo + https://us-east-1.console.aws.amazon.com/ec2/home

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
