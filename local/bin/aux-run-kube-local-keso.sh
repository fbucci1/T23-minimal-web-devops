cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++ Ejemplo keso - Recupera secretos por KESO y los envia en variables de entorno'${NC}'\n'

## 
## Desplegamos ejemplo 3 - Preparacion
##

printf ${TITLE}'++ Ejemplo KESO'${NC}'\n'

printf ${TITLE}'++++ Install Kubernetes external secrets operator support '${NC}'\n'

helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace --set installCRDs=true

##
## Desplegamos ejemplo 3 - Aplicacion que recupera secretos como variables de entorno. 
## Estos secretos son sincronizados a Kubernetes desde un servidor de Vault externo utilizando Kubernetes external operator
##

##
## Crea alias external-vault para acceder al vault server desde dentro de docker y minikube
##

INTERNAL_VAULT_NAME="external-vault"
printf "${TITLE}++ Creamos servicio proxy http://${INTERNAL_VAULT_NAME}:8200 en Kubernetes${NC}\n"

printf ${TITLE}'++++ Save host.docker.internal IP in env variable'${NC}'\n'
EXTERNAL_VAULT_IP=$(minikube ssh "dig short host.docker.internal|grep SERVER"|grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'|head -1)
if [[ ! "$EXTERNAL_VAULT_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then 
	printf ${ERROR}'!! ERROR: Valor IP recuperado no es valido: '${EXTERNAL_VAULT_IP}${NC}'\n'
	exit 1
fi
echo $EXTERNAL_VAULT_IP

printf ${TITLE}'++++ Checks docker IP works '$EXTERNAL_VAULT_IP' . Recupera la version de Vault Server'${NC}'\n'
curl -s $EXTERNAL_VAULT_IP:8200/v1/sys/seal-status |jq -r ".version"

printf ${TITLE}'++++ Genera endpoint para el acceso al vault server desde dentro de kubernetes'${NC}'\n'
TMP=/tmp/.ttt$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
cp ../../resources/kube-templates/template-deployment-keso-external-endpoint.yaml $TMP
sed -i -r "s/xxxEXTERNAL_VAULT_IPxxx/"$EXTERNAL_VAULT_IP"/g" $TMP
sed -i -r "s/xxxINTERNAL_VAULT_NAMExxx/"$INTERNAL_VAULT_NAME"/g" $TMP
kubectl apply -f $TMP

##
## Despliega otros servicios
##

printf ${TITLE}'++++ Despliega secretos'${NC}'\n'
cp ../../resources/kube-templates/template-deployment-keso-secrets.yaml $TMP
VAULT_ADDR="http://${INTERNAL_VAULT_NAME}:8200"
VAULT_USER=$(../../shared/bin/readers/read-VAULT_USER.sh)
VAULT_PASS=$(../../shared/bin/readers/read-VAULT_PASS.sh)
BASE64_VAULT_PASS=$(printf "$VAULT_PASS" | base64)
ESCAPED_VAULT_ADDR=(${VAULT_ADDR////\\/});
sed -i -r "s/xxxVAULT_ADDRxxx/"$ESCAPED_VAULT_ADDR"/g" $TMP
sed -i -r "s/xxxVAULT_USERxxx/"$VAULT_USER"/g" $TMP 
sed -i -r "s/xxxBASE64_VAULT_PASSxxx/"$BASE64_VAULT_PASS"/g" $TMP 
kubectl apply -f $TMP

printf ${TITLE}'++++ Despliega app y espera a que arranque'${NC}'\n'
kubectl apply -f ../../resources/kube-templates/deployment-keso-externalsecrets.yaml 
kubectl apply -f ../../resources/kube-templates/deployment-keso-pod.yaml 
kubectl apply -f ../../resources/kube-templates/deployment-keso-service.yaml 
sleep 5
kubectl wait --for=condition=ready pod -l "app=pod-keso" --timeout=99s

#kubectl get secretstore,externalsecret,secrets,pods
#kubectl describe secretstore secret-store-vault-server
#kubectl describe externalsecret external-secret-vault-server-app1
#kubectl describe secret sec-replicated-app
#kubectl get secret sec-replicated-app1 -o jsonpath='{.data}'
#kubectl describe pod -l app=pod-keso

printf ${TITLE}'++++ Arrancamos proxy y llamamos a la app para ver si le han llegado los secretos'${NC}'\n'
kubectl port-forward service/svc-keso 20002:80 &

printf ${TITLE}'++++ Llamamos al servicio a traves del proxy'${NC}'\n'
while ! curl -s http://localhost:20002
do printf 'will retry in 2 seconds\n'; sleep 2; done

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
