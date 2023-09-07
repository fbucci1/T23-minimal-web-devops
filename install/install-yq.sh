echo ++ Add repository
sudo add-apt-repository -y ppa:rmescandon/yq

echo ++ Update
sudo apt-get -q update

echo ++ Install
sudo apt install -q -y yq

echo ++ Show version if installed properly
yq --version
read -p "Press enter to continue"
