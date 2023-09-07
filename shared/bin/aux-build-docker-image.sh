cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

echo ++ Build app
./aux-build-all-npm.sh

echo ++ Build docker image
sudo docker build -t t23-minimal-web-w-lanzador ../../.. --file ../../resources/Dockerfile

echo ++ List docker images
sudo docker images | grep t23-minimal-web-w-lanzador

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
