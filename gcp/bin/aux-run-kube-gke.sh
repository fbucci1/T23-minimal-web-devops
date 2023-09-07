cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

##
## Generamos imagen docker de la app y la importamos en Artifactory Registry
##

printf ${TITLE}'++ Generamos imagen docker de nuestra app'${NC}'\n'

printf ${TITLE}'++++ Build docker image of the application'${NC}'\n'
../../shared/bin/aux-build-docker-image.sh 

printf ${TITLE}'++++ Import new image'${NC}'\n'
./aux-upload-docker-image-to-ar.sh

./aux-run-kube-gke-${T23_KUBE_CASE}.sh

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
