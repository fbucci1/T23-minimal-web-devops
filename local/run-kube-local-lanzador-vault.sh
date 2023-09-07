cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

export T23_SM_PROVIDER=vault
export T23_KUBE_CASE=lanzador
./bin/aux-run-kube-local.sh

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
