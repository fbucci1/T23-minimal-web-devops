cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

gcloud artifacts repositories delete t23myrepotesis \
    --location=us-central1

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
