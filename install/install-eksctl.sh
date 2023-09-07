ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

echo ++ Download
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

echo ++ Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
read -p "Press enter to continue"

echo ++ untar
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

echo ++ move
sudo mv /tmp/eksctl /usr/local/bin

echo ++ Show version if installed properly
eksctl version
read -p "Press enter to continue"
