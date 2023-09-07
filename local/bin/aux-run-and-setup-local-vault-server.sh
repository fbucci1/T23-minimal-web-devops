cd "$(dirname "$0")"
TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

printf ${TITLE}'++++ Retrieve user and password'${NC}'\n'
T23_SM_KEY="app1"
T23_SM_VAULT_USER=$(../../shared/bin/readers/read-VAULT_USER.sh)
T23_SM_VAULT_PASS=$(../../shared/bin/readers/read-VAULT_PASS.sh)

printf ${TITLE}'++++ Setting vault server env variables'${NC}'\n'
export VAULT_ADDR=$(../../shared/bin/readers/read-VAULT_ADDR.sh)
export VAULT_TOKEN=$(../../shared/bin/readers/read-VAULT_ROOT_PASS.sh)

printf ${TITLE}'++++++ Starting vault server'${NC}'\n'
nohup sudo vault server -dev -dev-listen-address "0.0.0.0:8200" -dev-root-token-id "$VAULT_TOKEN" >/tmp/vault-server.stdout 2>&1 &
sleep 5 && stty sane

printf ${TITLE}'++++++ Wait for Vault server to be live'${NC}'\n'
while ! curl --silent --output /dev/null ${VAULT_ADDR}
do printf 'will retry in 2 seconds\n'; sleep 2; done

#printf ${TITLE}'++++++ Enabling vault server audit
#vault audit enable file file_path=/tmp/vault.log

##
## Creamos secreto de ejemplo y permiso para leerlo y accedenos por API
##

printf ${TITLE}'++ Creamos secreto de ejemplo y lo accedemos por API'${NC}'\n'
printf ${TITLE}'++++ Creating sample secret'${NC}'\n'
vault kv put -mount=secret ${T23_SM_KEY} first-secret=V1-A-secret-in-HashicorpVault second-secret=V2-A-secret-in-HashicorpVault

printf ${TITLE}'++++ Recuperamos sample secret using API como root'${NC}'\n'
VAULT_JWTOKEN=$(vault token create --format=json | jq -r ".auth.client_token")
curl -s --header "X-Vault-Token: $VAULT_JWTOKEN" --request GET ${VAULT_ADDR}/v1/secret/data/${T23_SM_KEY} | jq -c ".data.data"

printf ${TITLE}'++++ Write out a policy named ${T23_SM_KEY} that enables the read capability for secrets at path secret/data/${T23_SM_KEY}'${NC}'\n'
# IMPORTANTE Path es muy sensible. 
# Para acceder a los secretos en secret/${T23_SM_KEY} hay que poner "secret/data/${T23_SM_KEY}" 
# No lleva / ni al principio ni final. Imagino que es el path del la API lo que vale.
# En caso de error, probar con "*"
vault policy write policy${T23_SM_KEY} - <<EOF
path "secret/data/${T23_SM_KEY}" {
  capabilities = ["read"]
}
EOF

printf ${TITLE}'++++ Habilita autenticación de usuarios por usuario y contraseña. Crea usuario de ejemplo con esa politica.'${NC}'\n'
vault auth enable userpass
vault write auth/userpass/users/${T23_SM_VAULT_USER} password=${T23_SM_VAULT_PASS} policies=Policy${T23_SM_KEY}

printf ${TITLE}'++++ Crea token usando la API de login y recupera secreto usando la API de get secret/data'${NC}'\n'
export VAULT_JWTOKEN=$(curl -s --request POST --data '{"password": "${T23_SM_VAULT_PASS}"}' ${VAULT_ADDR}/v1/auth/userpass/login/${T23_SM_VAULT_USER} | jq -r ".auth.client_token")
curl -s --header "X-Vault-Token: $VAULT_JWTOKEN" --request GET ${VAULT_ADDR}/v1/secret/data/${T23_SM_KEY} | jq -c ".data.data"

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
