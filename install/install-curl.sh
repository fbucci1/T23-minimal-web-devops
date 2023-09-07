echo ++ Download
sudo apt-get -q update
sudo apt-get install -y -q curl

echo ++ Show version if installed properly
curl --version
read -p "Press enter to continue"
