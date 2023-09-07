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

# hay que valorizar todaz las propiedades del template antes de hacer nada
TMP=/tmp/.ttt$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
cp ../../aws/resources/template-deployment-cloud-lanzador-secrets.yaml $TMP
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

printf ${TITLE}'++++ Despliega app'${NC}'\n'
#Reemplaza coordenadas de la imagen en artifact repostory
export IMAGE=t23myrepotesis.azurecr.io/t23-minimal-web-w-lanzador

TMP=/tmp/.ttt$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
cp ../../aws/resources/template-deployment-cloud-lanzador-pod.yaml $TMP
sed -i -r "s@xxxIMAGExxx@"$(printf "$IMAGE")"@g" $TMP
kubectl apply -f $TMP

printf ${TITLE}'++++ Despliega servicio'${NC}'\n'
kubectl apply -f ../../aws/resources/deployment-cloud-lanzador-service.yaml 

sleep 5
kubectl wait --for=condition=ready pod -l "app=pod-lanzador" --timeout=99s

echo ++ Get Pods - Expecting Pod depl-lanzador
kubectl get pods

echo ++ Get services - Expecting Load Balancer svc-lanzador
kubectl get svc

echo ++ Get the external IP of the LoadBalancer service
sleep 60
EXTERNAL_IP=$(kubectl get svc "svc-lanzador" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
if [ -z "$EXTERNAL_IP" ]; then
  echo "The external IP is not available yet. The service is still pending..."
else
  echo "++ Test using: curl $EXTERNAL_IP"
  while ! curl http://$EXTERNAL_IP
  do echo "will retry in 2 seconds"; sleep 2; done
  echo .
fi

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
