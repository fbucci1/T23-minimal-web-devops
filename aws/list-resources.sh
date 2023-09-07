cd "$(dirname "$0")"

TITLE='\033[4;32m'
NC='\033[0m' # No Color

sudo printf "${TITLE}++ Empezando ${0##*/}${NC}\n"

sudo printf "${TITLE}++ ECR Repositories${NC}\n"
aws ecr describe-repositories --output=text

sudo printf "${TITLE}++ EKS Clusters${NC}\n"
aws eks list-clusters --output=text

sudo printf "${TITLE}++ EC2 Instances${NC}\n"
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,State.Name]' --output=text

sudo printf "${TITLE}++ EC2 Volumes${NC}\n"
aws ec2 describe-volumes --query 'Volumes[*].[VolumeId,Size,AvailabilityZone,State]' --output=text

sudo printf "${TITLE}++ EC2 Autoscaling groups${NC}\n"
aws autoscaling describe-auto-scaling-groups --output=text

sudo printf "${TITLE}++ EC2 Elastic IP Addresses${NC}\n"
aws ec2 describe-addresses --output=text

printf "${TITLE}++ Listo ${0##*/}${NC}\n"
