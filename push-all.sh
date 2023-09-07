cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

printf ${TITLE}'++ Enmpezamos'${NC}'\n'

cd ../T23-minimal-web
../T23-minimal-web-devops/shared/bin/push.sh

cd ../T23-lanzador
../T23-minimal-web-devops/shared/bin/push.sh

cd ../T23-cliente-gestor-secretos
../T23-minimal-web-devops/shared/bin/push.sh

cd ../T23-shared-utils
../T23-minimal-web-devops/shared/bin/push.sh

cd ../T23-minimal-web-devops
../T23-minimal-web-devops/shared/bin/push.sh

cd ../T23-minimal-web-devops
../T23-minimal-web-devops/shared/bin/push.sh

printf ${TITLE}'++ Ready'${NC}'\n'
