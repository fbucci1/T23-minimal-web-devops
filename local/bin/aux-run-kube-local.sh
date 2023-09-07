cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

##
## Inicia Minikube
##
printf ${TITLE}'++ Iniciando servicios'${NC}'\n'

printf ${TITLE}'++++ Starting and cleaning minikube'${NC}'\n'
printf ${TITLE}'++++++ Starting and cleaning minikube'${NC}'\n'
if [[ "$(minikube status|grep -o Stopped)" =~ Stopped ]]; then 
	minikube start; 
else
	printf 'Already running\n'
fi

sudo printf "${TITLE}++ Stop it all${NC}\n"
./../clean-kube-local.sh

##
## Inicia Vault server
##

printf ${TITLE}'++++++ Starting vault server'${NC}'\n'
./aux-run-and-setup-local-vault-server.sh

##
## Generamos imagen docker de la app y la importamos en minikube
##

printf ${TITLE}'++ Generamos imagen docker de nuestra app'${NC}'\n'

printf ${TITLE}'++++ Build docker image of the application'${NC}'\n'
../../shared/bin/aux-build-docker-image.sh 

printf ${TITLE}'++++ Delete previous image in minikube'${NC}'\n'
minikube image rm t23-minimal-web-w-lanzador

printf ${TITLE}'++++ Import new image'${NC}'\n'
minikube image load t23-minimal-web-w-lanzador | grep t23-minimal-web-w-lanzador

./aux-run-kube-local-${T23_KUBE_CASE}.sh

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
