cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

printf ${TITLE}'++ Enmpezamos'${NC}'\n'

cd ../T23-minimal-web
pwd
cloc --exclude-dir=node_modules --quiet .

cd ../T23-lanzador
pwd
cloc --exclude-dir=node_modules --quiet .

cd ../T23-cliente-gestor-secretos
pwd
cloc --exclude-dir=node_modules --quiet .

cd ../T23-shared-utils
pwd
cloc --exclude-dir=node_modules --quiet .

cd ../T23-minimal-web-devops
pwd
cloc --exclude-dir=node_modules --quiet .

printf ${TITLE}'++ Ready'${NC}'\n'
