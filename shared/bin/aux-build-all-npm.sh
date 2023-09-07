cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

cd ..
cd ..

cd ../T23-shared-utils
cd src
sudo npm install -g local-package-publisher
cd ..

cd ../T23-cliente-gestor-secretos
cd src
sudo npm install -g local-package-publisher
cd ..

cd ../T23-lanzador
cd src
npm install
cd ..

cd ../T23-minimal-web
cd src
npm install
cd ..

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
