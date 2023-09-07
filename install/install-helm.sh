echo ++ Download install script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh

echo ++ Install
./get_helm.sh
rm ./get_helm.sh

echo ++ Show version if installed properly
helm version
read -p "Press enter to continue"
