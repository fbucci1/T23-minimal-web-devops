echo ++ Installing HCP Vault Secrets CLI

#Version local
#sudo apt update
#sudo apt install vault -y

#Version EC2 Ubuntu
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

echo ++ Show version if installed properly
vault --version
read -p "Press enter to continue"
