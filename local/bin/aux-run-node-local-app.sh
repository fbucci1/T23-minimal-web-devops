cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++ Stop it all${NC}\n"
../stop-node-local.sh

printf ${TITLE}'++++ Starting vault server'${NC}'\n'
./aux-run-and-setup-local-vault-server.sh

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
#Sample secret
export T23_SECRET_1=E1-A-secret-from-script
export T23_SECRET_2=E2-A-secret-from-script
export T23_FILE_PATH=./config/test-config.json
export T23_LA_OUT_FILE=./config/test-config.json
###############################################
###############################################
###############################################

printf ${TITLE}'++ Cambia de directorio y actualiza dependencias'${NC}'\n'
cd ../../../T23-minimal-web/src
npm install

printf ${TITLE}'++ Arranca'${NC}'\n'
node server.js & 

printf ${TITLE}'++ Check endpoint is live'${NC}'\n'
while ! curl -s http://localhost:3000
do printf 'will retry in 2 seconds\n'; sleep 2; done

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
