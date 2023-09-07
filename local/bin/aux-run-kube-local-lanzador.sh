cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++ Ejemplo de lanzador corriendo en kubernetes sin KESO ni secretos inyectados desde Kube Secrets'${NC}'\n'
printf ${TITLE}'   Esta prueba abarca tanto al lanzador recuperando secretos como a la app usando la API...'${NC}'\n'

printf ${TITLE}'++++++ Setting vault server env variables'${NC}'\n'
export VAULT_ADDR=$(../../shared/bin/readers/read-VAULT_ADDR.sh)
export VAULT_TOKEN=$(../../shared/bin/readers/read-VAULT_ROOT_PASS.sh)

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
    export T23_SM_AWS_REGION="ignore"
    export T23_SM_AWS_ACCESS_KEY_ID="ignore"
    export T23_SM_AWS_SECRET_ACCESS_KEY="ignore"
fi
#If aws retrieve properties from AWS CLI
if [ "$T23_SM_PROVIDER" == "aws" ]; then
    export T23_SM_VAULT_ADDR="ignore"
    export T23_SM_VAULT_USER="ignore"
    export T23_SM_VAULT_PASS="ignore"
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

printf ${TITLE}'++++ Despliega secreto'${NC}'\n'




#export T23_SM_PROVIDER=x
#export T23_SM_KEY=x
#export T23_SM_VAULT_ADDR=x
#export T23_SM_VAULT_USER=x
#export T23_SM_VAULT_PASS=x
#export T23_SM_AWS_REGION=x
#export T23_SM_AWS_ACCESS_KEY_ID=x
#export T23_SM_AWS_SECRET_ACCESS_KEY=x
#export T23_LA_OUT_FILE=x
#export T23_LA_OUT_FILE_FORMAT=x
#export T23_LA_ENV_READ_AND_SET_1=x
#export T23_LA_ENV_READ_AND_SET_2=x

# hay que valorizar todaz las propiedades del template antes de hacer nada
TMP=/tmp/.ttt$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
cp ../../resources/kube-templates/template-deployment-lanzador-secrets.yaml $TMP
sed -i -r "s/xxxBASE64_T23_SM_PROVIDERxxx/"$(printf "$T23_SM_PROVIDER" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_SM_KEYxxx/"$(printf "$T23_SM_KEY" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_SM_VAULT_ADDRxxx/"$(printf "$T23_SM_VAULT_ADDR" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_SM_VAULT_USERxxx/"$(printf "$T23_SM_VAULT_USER" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_SM_VAULT_PASSxxx/"$(printf "$T23_SM_VAULT_PASS" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_SM_AWS_REGIONxxx/"$(printf "$T23_SM_AWS_REGION" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_SM_AWS_ACCESS_KEY_IDxxx/"$(printf "$T23_SM_AWS_ACCESS_KEY_ID" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_SM_AWS_SECRET_ACCESS_KEYxxx/"$(printf "$T23_SM_AWS_SECRET_ACCESS_KEY" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_LA_OUT_FILExxx/"$(printf "$T23_LA_OUT_FILE" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_LA_OUT_FILE_FORMATxxx/"$(printf "$T23_LA_OUT_FILE_FORMAT" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_LA_ENV_READ_AND_SET_1xxx/"$(printf "$T23_LA_ENV_READ_AND_SET_1" | base64)"/g" $TMP
sed -i -r "s/xxxBASE64_T23_LA_ENV_READ_AND_SET_2xxx/"$(printf "$T23_LA_ENV_READ_AND_SET_2" | base64)"/g" $TMP
kubectl apply -f $TMP


printf ${TITLE}'++++ Despliega app y espera a que arranque'${NC}'\n'
kubectl apply -f ../../resources/kube-templates/deployment-lanzador-pod.yaml 
kubectl apply -f ../../resources/kube-templates/deployment-lanzador-service.yaml 
sleep 5
kubectl wait --for=condition=ready pod -l "app=pod-lanzador" --timeout=10s

printf ${TITLE}'++++ Arrancamos proxy y llamamos a la app para ver si le han llegado los secretos'${NC}'\n'
kubectl port-forward service/svc-lanzador 20002:80 &

printf ${TITLE}'++++ Llamamos al servicio a traves del proxy'${NC}'\n'
while ! curl -s http://localhost:20002
do printf 'will retry in 2 seconds\n'; sleep 2; done

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
