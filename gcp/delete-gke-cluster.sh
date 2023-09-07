cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

gcloud container clusters delete mygkecluster --location us-central1-a 

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
