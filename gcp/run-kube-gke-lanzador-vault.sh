cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

#export T23_SM_PROVIDER=no-aplica
export T23_KUBE_CASE=lanzador
export T23_SM_PROVIDER=vault

./bin/aux-run-kube-gke.sh

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
