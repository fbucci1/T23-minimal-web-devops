cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++++++ Borramos deployments que puedan haber quedado de despliegue anterior - necesario para importar la nueva imagen de docker'${NC}'\n'
kubectl delete --ignore-not-found=true deployment depl-secrets
kubectl delete --ignore-not-found=true deployment depl-lanzador
kubectl delete --ignore-not-found=true deployment depl-keso
kubectl delete --ignore-not-found=true deployment depl-vaultagent
kubectl wait --for=delete pod -l "app=pod-secrets" --timeout=60s
kubectl wait --for=delete pod -l "app=pod-lanzador" --timeout=60s
kubectl wait --for=delete pod -l "app=pod-keso" --timeout=60s
kubectl wait --for=delete pod -l "app=pod-vaultagent" --timeout=60s

kubectl delete --ignore-not-found=true svc svc-secrets
kubectl delete --ignore-not-found=true svc svc-lanzador
kubectl delete --ignore-not-found=true svc svc-keso
kubectl delete --ignore-not-found=true svc svc-vaultagent

kubectl delete --ignore-not-found=true secretstore secret-store-vault-server
kubectl delete --ignore-not-found=true externalsecret external-secret-vault-server-app1

kubectl delete --ignore-not-found=true secret sec-app1-secret
kubectl delete --ignore-not-found=true secret sec-vault-token
kubectl delete --ignore-not-found=true secret sec-replicated-app1
kubectl delete --ignore-not-found=true secret sec-vault-token

printf ${TITLE}'++++++ Esto es lo que queda en el namespace default'${NC}'\n'
#kubectl get all -n default
kubectl get secretstore,externalsecret,secrets,pods,service,deployment -n default

printf ${TITLE}'++++ Matamos kubectl proxies que puedan haber quedado'${NC}'\n'
sudo pkill kubectl

printf ${TITLE}'++ Stop vault server'${NC}'\n'
./local/bin/aux-stop-local-vault-server.sh

#No se detiene. Falta: minikube stop

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
