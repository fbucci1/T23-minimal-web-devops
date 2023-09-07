cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

AWS_ACCOUNT_ID=$(../../shared/bin/readers/read-AWS_ACCOUNT_ID.sh)

echo ++ Relate docker image with ECR repo URL
sudo docker tag t23-minimal-web-w-lanzador $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/tesis-repo

echo ++ Relate docker to AWS authentication
aws ecr get-login-password --profile default --region us-east-1  | sudo docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

echo ++ Push docker image to ECR
sudo docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/tesis-repo

echo ++ See repo and image in https://us-east-1.console.aws.amazon.com/ecr/repositories

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
