cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++ Ejemplo secrets - Envía Kubernetes Secrets en variables de entorno'${NC}'\n'

printf ${TITLE}'++++ Despliega app'${NC}'\n'
#Reemplaza coordenadas de la imagen en artifact repostory
export AWS_ACCOUNT_ID=$(../../shared/bin/readers/read-AWS_ACCOUNT_ID.sh)
export IMAGE=$AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/tesis-repo

TMP=/tmp/.ttt$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
cp ../../aws/resources/template-deployment-cloud-lanzador-pod.yaml $TMP
sed -i -r "s@xxxIMAGExxx@"$(printf "$IMAGE")"@g" $TMP
kubectl apply -f $TMP

printf ${TITLE}'++++ Despliega servicio'${NC}'\n'
kubectl apply -f ../resources/deployment-cloud-lanzador-service.yaml 

sleep 5
kubectl wait --for=condition=ready pod -l "app=pod-lanzador" --timeout=99s

echo ++ Get Pods - Expecting Pod depl-lanzador
kubectl get pods

echo ++ Get services - Expecting Load Balancer svc-lanzador
kubectl get svc

echo ++ Get the external IP of the LoadBalancer service
sleep 60
kubectl wait --for=condition=ready pod -l "app=pod-secrets" --timeout=99s

echo ++ Get Pods - Expecting Pod depl-secrets
kubectl get pods

echo ++ Get services - Expecting Load Balancer svc-secrets
kubectl get svc

echo ++ Get the external IP of the LoadBalancer service
EXTERNAL_IP=$(kubectl get svc "svc-secrets" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
if [ -z "$EXTERNAL_IP" ]; then
  echo "The external IP is not available yet. The service is still pending..."
else
  echo "++ Test using: curl $EXTERNAL_IP"
  while ! curl http://$EXTERNAL_IP
  do echo "will retry in 2 seconds"; sleep 2; done
  echo .
fi

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
