cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

gcloud init

PROJECT_ID=$(gcloud config get-value project)
echo PROJECT_ID: $PROJECT_ID

gcloud artifacts repositories create t23myrepotesis \
    --project=$PROJECT_ID \
    --repository-format=docker \
    --location=us-central1 \
    --description="Docker repository"

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
