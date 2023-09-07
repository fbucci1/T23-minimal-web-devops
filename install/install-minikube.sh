echo ++ Installing apt-transport-https
sudo apt-get update && sudo apt-get install -y apt-transport-https

echo ++ Installing kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

echo ++ Installing Munikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo ++ Show version if installed properly
minikube version
read -p "Press enter to continue"

echo ++ Adding user to docker group
sudo groupadd docker
sudo usermod -aG docker $USER

echo ++ IMPORTANT: Restart server for changes in permissions to apply
read -p "IMPORTANT!!!! restart server after installation"
#shutdown -r
