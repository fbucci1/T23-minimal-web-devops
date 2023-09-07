echo ++ Install python-pip
sudo apt-get install python3-pip

echo ++ Install pip3 awscli
sudo pip3 install awscli 

echo ++ Upgrade pip3 awscli
sudo pip3 install --upgrade awscli

echo ++ awscliv2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

echo ++ Unzip
unzip awscliv2.zip

echo ++ Install
sudo ./aws/install --update

echo ++ Clean up
rm awscliv2.zip
rm -rf aws

echo ++ Show version if installed properly
aws --version
read -p "Press enter to continue"
