echo ++ Installing HCP Vault Secrets CLI
sudo apt update

echo ++ Add repository
rm /usr/share/keyrings/hashicorp-archive-keyring.gpg
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

echo ++ Update again
sudo apt update

echo ++ Install
sudo apt install vlt -y

echo ++ Show version if installed properly
vlt --version
read -p "Press enter to continue"
