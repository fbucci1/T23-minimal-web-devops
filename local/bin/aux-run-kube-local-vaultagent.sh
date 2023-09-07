cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++ Ejemplo usando Vault Agent propietario de Hasicorp'${NC}'\n'

printf ${TITLE}'++++++ Setting vault server env variables'${NC}'\n'
export VAULT_ADDR=$(../../shared/bin/readers/read-VAULT_ADDR.sh)
export VAULT_TOKEN=$(../../shared/bin/readers/read-VAULT_ROOT_PASS.sh)
export T23_SM_KEY=app1

## 
## Desplegamos Preparacion
##

printf ${TITLE}'++ Preparacion'${NC}'\n'

printf ${TITLE}'++++ Add Hashicorp repository in Helm'${NC}'\n'
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

#printf ${TITLE}'++++ Quitamos el sidecar y lo volvemos a instalar porque sino no lo vuelve a instalar (lo borramos al hacer delete all)'${NC}'\n'
#helm uninstall vault hashicorp/vault

printf ${TITLE}'++++ Despliega pods del sidecar y espera a que arranque'${NC}'\n'
helm install vault hashicorp/vault --set "global.externalVaultAddr=$VAULT_ADDR" --set "csi.debug=true" --set "injector.logLevel=trace" --set "server.logLevel=trace"
sleep 5
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=vault-agent-injector --timeout=99s

printf ${TITLE}'++++ Confirma que serviceaccount vault existe'${NC}'\n'
kubectl describe serviceaccount vault

printf ${TITLE}'++++ Create a vault-secret'${NC}'\n'
kubectl apply -f ../../resources/kube-templates/deployment-vaultagent-internal-secret.yaml
printf ${TITLE}'++++ Recupera el nombre del secreto'${NC}'\n'
VAULT_HELM_SECRET_NAME=$(kubectl get secrets --output=json | jq -r '.items[].metadata | select(.name|startswith("vault-token-")).name')
echo $VAULT_HELM_SECRET_NAME

printf ${TITLE}'++++ Recupera el token generado por el injector'${NC}'\n'
kubectl get secret $VAULT_HELM_SECRET_NAME -o json|jq -r ".data.token" | head --bytes=50

####
#### Paso: Configura la autenticacion con Kubernetes en el vault server
####

printf ${TITLE}'++++ Configura autenticacion de usuarios de kubernetes en el vault server'${NC}'\n'

printf ${TITLE}'++++++ Enable the Kubernetes authentication method.'${NC}'\n'
vault auth enable kubernetes

printf ${TITLE}'++++++ Get the JWT from the secret.'${NC}'\n'
TOKEN_REVIEW_JWT=$(kubectl get secret $VAULT_HELM_SECRET_NAME --output='go-template={{ .data.token }}' | base64 --decode)
echo ${TOKEN_REVIEW_JWT:0:50}...

printf ${TITLE}'++++++ Retrieve the Kubernetes CA certificate.'${NC}'\n'
KUBE_CA_CERT=$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)
echo ${KUBE_CA_CERT:0:50}...

printf ${TITLE}'++++++ Retrieve the Kubernetes host URL.'${NC}'\n'
KUBE_HOST=$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.server}')
echo $KUBE_HOST

printf ${TITLE}'++++++ Configure the Kubernetes authentication method to use the service account token, the location of the Kubernetes host, its certificate, and its service account issuer name.'${NC}'\n'
vault write auth/kubernetes/config \
     token_reviewer_jwt="$TOKEN_REVIEW_JWT" \
     kubernetes_host="$KUBE_HOST" \
     kubernetes_ca_cert="$KUBE_CA_CERT" \
     issuer="https://kubernetes.default.svc.cluster.local"

####
#### Paso: Crea cuenta de servicio en kubernetes
####

printf ${TITLE}'++++ Create accout in kubernetes'${NC}'\n'
printf ${TITLE}'++++++ Create service account internal-app1 in Kubernetes'${NC}'\n'
kubectl create sa internal-app1

printf ${TITLE}'++++++ Create a Kubernetes authentication role named role-app1 and link to internal-app1 and policy app1 in Vault server'${NC}'\n'
vault write auth/kubernetes/role/role-app1 \
     bound_service_account_names=internal-app1 \
     bound_service_account_namespaces=default \
     policies=policy${T23_SM_KEY} \
     ttl=24h


####
#### Paso: Descarga la imagen del agente, desde minikube no lo hace por defecto
####

printf ${TITLE}'++++ Descargamos la imagen de hashicorp/vault desde docker y la importamos en minikube - es necesaria para el vault agent sidecar'${NC}'\n'
if [[ -z "$(minikube image ls|grep -o docker.io/hashicorp/vault:|head -1)" ]]; then 
     docker pull hashicorp/vault:1.14.0
     minikube image load docker.io/hashicorp/vault:1.14.0
     minikube image ls | grep docker.io/hashicorp/vault
else 
     echo 'Already available in minikube... skipping.' 
fi

##
## Desplegamos Aplicacion que recupera secretos desde fichero inyectado por vault agent sidecar
##

printf ${TITLE}'++ Despliegue'${NC}'\n'

printf ${TITLE}'++++ Despliega app y espera a que arranque'${NC}'\n'
kubectl apply -f ../../resources/kube-templates/deployment-vaultagent-pod.yaml 
kubectl apply -f ../../resources/kube-templates/deployment-vaultagent-service.yaml 
sleep 5
kubectl wait --for=condition=ready pod -l "app=pod-vaultagent" --timeout=10s

#printf ${TITLE}'++ Miramos los logs del agente'${NC}'\n'
#kubectl logs $(kubectl get pods -l "app=pod-vaultagent" -o name) --container vault-agent-init

#printf ${TITLE}'++ Miramos el fichero de secretos'${NC}'\n'
#kubectl exec -it $(kubectl get pods -l "app=pod-vaultagent" -o name) -c cont-vaultagent -- cat /vault/secrets/app1.properties

#printf ${TITLE}'Llamamos a la app para ver si puede acceder al ficheros de secretos inyectado'${NC}'\n'
#kubectl exec -it $(kubectl get pods -l "app=pod-vaultagent" -o name) -c cont-vaultagent -- wget -q -O - localhost:3000
#kubectl exec -it $(kubectl get pods -l "app=pod-vaultagent" -o name) -c cont-vaultagent -- wget -q -O - localhost:3000/secret

printf ${TITLE}'++++ Arrancamos proxy y llamamos a la app para ver si le han llegado los secretos'${NC}'\n'
kubectl port-forward service/svc-vaultagent 20001:80 &

printf ${TITLE}'++++ Llamamos al servicio a traves del proxy'${NC}'\n'
while ! curl -s http://localhost:20001
do printf 'will retry in 2 seconds\n'; sleep 2; done

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
