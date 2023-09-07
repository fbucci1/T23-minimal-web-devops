echo ++ Update
sudo apt-get -q update

echo ++ Install
sudo apt install -q -y jq

echo ++ Show version if installed properly
jq --version
read -p "Press enter to continue"
