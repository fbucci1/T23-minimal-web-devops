echo ++ Update
sudo apt update

echo ++ Install
sudo dpkg --remove --force-remove-reinstreq libnode-dev
sudo dpkg --remove --force-remove-reinstreq libnode72:amd64
sudo apt-get remove -y libnode-dev
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

echo ++ Show version if installed properly
node -v
read -p "Press enter to continue"
