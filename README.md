# T23-minimal-web-devops

Creación del workspace:
    mkdir workspace
    cd workspace
    cd /T23-minimal-web
    git clone git@github.com:fbucci1/T23-minimal-web.git
    cd ../T23-lanzador
    git clone git@github.com:fbucci1/T23-lanzador.git
    cd ../T23-cliente-gestor-secretos
    git clone git@github.com:fbucci1/T23-cliente-gestor-secretos.git
    cd ../T23-shared-utils
    git clone git@github.com:fbucci1/T23-shared-utils.git
    cd ../T23-minimal-web-devops
    git clone git@github.com:fbucci1/T23-minimal-web-devops.git

Las credenciales del vault se almacenan localmente fuera de git, en el fichero ~/.vault/credentials
Ejemplo del contenido:
´´´
[default]
VAULT_PASS=<user>
VAULT_USER=<pass>

#external-vault es el hostname interno en minikube para acceder al vault server. 
#Crear ademas un alias en hosts del estilo 192.169.x.x external-vault
VAULT_ADDR=http://external-vault:8200

#Para utilizar un vault server en la nube, usamos su IP o hostname y el puerto correcto. Por simplicidad usamos el 80.
#VAULT_ADDR=http://<IP>

#El token del usuario root de hashicorp vault para poder crear los recursos necesarios en la prueba.
VAULT_ROOT_PASS=<user>

AWS_ACCESS_KEY_ID=<token>
AWS_SECRET_ACCESS_KEY_KEY=<token>
AWS_ACCOUNT_ID=<ID-de-la-cuenta-de-AWS>
AWS_REGION=us-east-1
´´´