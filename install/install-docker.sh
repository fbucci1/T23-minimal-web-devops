echo ++ Download
curl -fsSL https://get.docker.com -o get-docker.sh

echo ++ Install
sudo sh ./get-docker.sh

echo ++ Cleaning up
rm get-docker.sh

echo ++Starting docker service
sudo service docker start

echo ++ Show version if installed properly
docker --version
read -p "Press enter to continue"
