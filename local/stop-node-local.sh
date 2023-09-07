cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++ Stop all node servers'${NC}'\n'
sudo killall -v -9 "node"

printf ${TITLE}'++ List containers'${NC}'\n'
sudo ps -aux|grep "node server.js"

./bin/aux-stop-local-vault-server.sh

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
