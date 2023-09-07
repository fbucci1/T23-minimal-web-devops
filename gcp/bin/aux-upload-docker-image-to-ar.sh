cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

gcloud auth configure-docker us-central1-docker.pkg.dev

PROJECT_ID=$(gcloud config get-value project)
echo PROJECT_ID: $PROJECT_ID

sudo docker tag t23-minimal-web-w-lanzador \
    us-central1-docker.pkg.dev/$PROJECT_ID/t23myrepotesis/t23-minimal-web-w-lanzador

docker push us-central1-docker.pkg.dev/$PROJECT_ID/t23myrepotesis/t23-minimal-web-w-lanzador

echo ++ See repo and image in https://console.cloud.google.com/artifacts

printf "${TITLE}++ Listo ${0##*/}${NC}\n"


