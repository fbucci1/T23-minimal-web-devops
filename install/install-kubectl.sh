echo ++ Updating packages
sudo apt-get -q update

echo ++ Installing 1
sudo apt-get install -q -y ca-certificates curl

echo ++ Installing 2
sudo apt-get install -q -y apt-transport-https

echo ++ Adding repo
if [ ! -f  /etc/apt/keyrings/kubernetes-archive-keyring.gpg ]
then
	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
	echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
fi

echo ++ Updating packages
sudo apt-get -q update

echo ++ Installing 3
sudo apt-get install -q -y kubectl

echo ++ Show version if installed properly
kubectl version --client=true
read -p "Press enter to continue"

