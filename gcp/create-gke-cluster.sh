cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

#https://cloud.google.com/migrate/containers/docs/config-dev-env?hl=es-419
gcloud services enable container.googleapis.com

gcloud container clusters create mygkecluster \
    --zone us-central1-a \
    --node-locations us-central1-a \
    --num-nodes=1 --max-nodes=1 --total-max-nodes=1 \
    --machine-type=e2-standard-2 --disk-size=10GB

gcloud container clusters get-credentials mygkecluster --location us-central1-a

kubectl get nodes

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
