cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++ Stop containers'${NC}'\n'
if [ ! -z "$( sudo docker container ls -q --filter ancestor=t23-minimal-web-w-lanzador )" ]; then
    docker stop $(docker ps -a --filter ancestor=t23-minimal-web-w-lanzador --format="{{.ID}}")
    docker rm $(docker ps -a --filter ancestor=t23-minimal-web-w-lanzador --format="{{.ID}}")
else
	echo "No containers running"
fi

printf ${TITLE}'++ Delete images'${NC}'\n'
sudo docker rmi t23-minimal-web-w-lanzador

printf ${TITLE}'++ List containers'${NC}'\n'
sudo docker ps --all|grep minimal-web

printf ${TITLE}'++ Stop vault server'${NC}'\n'
./bin/aux-stop-local-vault-server.sh

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
