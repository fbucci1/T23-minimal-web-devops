cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++ Ejemplo secrets - Envía Kubernetes Secrets en variables de entorno'${NC}'\n'

printf ${TITLE}'++++ Despliega app y espera a que arranque'${NC}'\n'
kubectl apply -f ../../resources/kube-templates/deployment-secrets-secrets.yaml 
kubectl apply -f ../../resources/kube-templates/deployment-secrets-pod.yaml 
kubectl apply -f ../../resources/kube-templates/deployment-secrets-service.yaml 
sleep 5
kubectl wait --for=condition=ready pod -l "app=secrets" --timeout=99s

printf ${TITLE}'++++ Arrancamos proxy y llamamos a la app para ver si le han llegado los secretos'${NC}'\n'
kubectl port-forward service/svc-secrets 20003:80 &

printf ${TITLE}'++++ Llamamos al servicio a traves del proxy'${NC}'\n'
while ! curl -s http://localhost:20003
do printf 'will retry in 2 seconds\n'; sleep 2; done

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
