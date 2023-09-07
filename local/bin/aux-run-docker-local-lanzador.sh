cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++ Stop it all${NC}\n"
../clean-docker-lanzador.sh

##
## Inicia Vault server
##

printf ${TITLE}'++++++ Starting vault server'${NC}'\n'
./aux-run-and-setup-local-vault-server.sh

../../shared/bin/aux-build-docker-image.sh 

###############################################
###############################################
###############################################
#Propiedades generales: aws o vault
#export T23_SM_PROVIDER=vault
export T23_SM_KEY=app1
#Propiedades hashicorp vault
if [ "$T23_SM_PROVIDER" == "vault" ]; then
    export T23_SM_VAULT_ADDR=$(../../shared/bin/readers/read-VAULT_ADDR.sh)
    export T23_SM_VAULT_USER=$(../../shared/bin/readers/read-VAULT_USER.sh)
    export T23_SM_VAULT_PASS=$(../../shared/bin/readers/read-VAULT_PASS.sh)
fi
#If aws retrieve properties from AWS CLI
if [ "$T23_SM_PROVIDER" == "aws" ]; then
    export T23_SM_AWS_REGION=$(../../shared/bin/readers/read-AWS_REGION.sh)
    export T23_SM_AWS_ACCESS_KEY_ID=$(../../shared/bin/readers/read-AWS_ACCESS_KEY_ID.sh)
    export T23_SM_AWS_SECRET_ACCESS_KEY=$(../../shared/bin/readers/read-AWS_SECRET_ACCESS_KEY.sh)
fi
#Propiedades del launcher
export T23_LA_OUT_FILE=/tmp/config-generated.json
export T23_LA_OUT_FILE_FORMAT=json
export T23_LA_ENV_READ_AND_SET_1="first-secret,T23_SECRET_1"
export T23_LA_ENV_READ_AND_SET_2="second-secret,T23_SECRET_2"
export T23_LA_CMD_APP="node ../../T23-minimal-web/src/server.js > /tmp/server.js.log 2>&1"
###############################################
###############################################
###############################################

printf ${TITLE}'++ Run docker container'${NC}'\n'
sudo docker run -d --name run-docker-lanzador \
	-p 3000:3000 \
	-e "T23_SM_PROVIDER=${T23_SM_PROVIDER}" \
	-e "T23_SM_KEY=${T23_SM_KEY}" \
	-e "T23_SM_VAULT_ADDR=${T23_SM_VAULT_ADDR}" \
	-e "T23_SM_VAULT_USER=${T23_SM_VAULT_USER}" \
	-e "T23_SM_VAULT_PASS=${T23_SM_VAULT_PASS}" \
	-e "T23_SM_AWS_REGION=${T23_SM_AWS_REGION}" \
	-e "T23_SM_AWS_ACCESS_KEY_ID=${T23_SM_AWS_ACCESS_KEY_ID}" \
	-e "T23_SM_AWS_SECRET_ACCESS_KEY=${T23_SM_AWS_SECRET_ACCESS_KEY}" \
	-e "T23_LA_OUT_FILE=${T23_LA_OUT_FILE}" \
	-e "T23_LA_OUT_FILE_FORMAT=${T23_LA_OUT_FILE_FORMAT}" \
	-e "T23_LA_ENV_READ_AND_SET_1=${T23_LA_ENV_READ_AND_SET_1}" \
	-e "T23_LA_ENV_READ_AND_SET_2=${T23_LA_ENV_READ_AND_SET_2}" \
	-e "T23_LA_CMD_APP=${T23_LA_CMD_APP}" \
	t23-minimal-web-w-lanzador

printf ${TITLE}'++ List containers'${NC}'\n'
sudo docker ps --all|grep minimal-web-w-lanzador

printf ${TITLE}'++ Check endpoint is live'${NC}'\n'
while ! curl -s http://localhost:3000
do printf 'will retry in 2 seconds\n'; sleep 2; done

printf ${TITLE}'++ Muestra los logs del contenedor'${NC}'\n'
docker logs run-docker-lanzador

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
