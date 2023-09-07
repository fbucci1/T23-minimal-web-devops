cd "$(dirname "$0")"
TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++++++ Matamos vault server'${NC}'\n'
sudo pkill vault

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
