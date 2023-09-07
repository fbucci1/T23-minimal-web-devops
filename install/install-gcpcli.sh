echo ++ Install

sudo apt-get update

sudo apt-get install apt-transport-https ca-certificates gnupg curl sudo

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

sudo apt-get update 

sudo apt-get install -y google-cloud-cli

sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin

echo ++ Show version if installed properly
gcloud --version
read -p "Press enter to continue"
