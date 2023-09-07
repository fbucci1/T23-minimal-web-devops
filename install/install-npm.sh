echo ++ Update
sudo apt-get -q update

echo ++ Install
sudo apt install -q -y npm

echo ++ Show version if installed properly
npm -v
read -p "Press enter to continue"
