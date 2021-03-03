command -v aws >/dev/null 2>&1 || { echo >&2 "This script requires AWS CLI. Please install that first."; exit 1; }
testflag=false
while getopts k:e:t opt; do
  case "$opt" in
    k) keypath="$OPTARG";;
    e) envcode="$OPTARG";;
    t) testflag=true;;
    \?) echo "Usage: $0 <-k path-to-key> <-e env-code> [-t]";
	   echo "  -k to specify ssh key to use"
	   echo "  -e to specify which environment (dev-emu or qa)"
	   echo "  -t to test (doesn't actually start the tunnel)"
	  exit 2;;
  esac
done
#echo "Debug: $OPTIND options specified."
if [ "$OPTIND" -lt "5" ]
then
	echo "Missing required options. See usage ($0 -?)"
	exit 3
fi

shift $((OPTIND - 1))

echo "Fetching endpoint for $envcode"
endpoint=`aws ec2 describe-vpc-endpoints --filters Name=tag:Name,Values=nuxeo-$envcode-blitline-privatelink --query 'VpcEndpoints[*].DnsEntries[0].DnsName' --output text`

if [ -z "$endpoint" ]
then
	echo "Failed to find endpoint."
	exit 4
fi

echo "Fetching instance for $envcode"
instance=`aws ec2 describe-instances --filters Name=tag:Name,Values=nuxeo-$envcode-app-cluster-front Name=instance-state-name,Values=running --region us-west-2 --query 'Reservations[*].Instances[*].InstanceId' --output text`

if [ -z "$instance" ]
then
	echo "Failed to find instance."
fi

if $testflag
then
	echo "Tunnel would have been to $endpoint via $instance using $keypath."
	exit -1
fi
echo "Tunnelling to $envcode"
echo "ssh -i $keypath -L 3000:$endpoint:80 ubuntu@$instance"
ssh -i $keypath -L 3000:$endpoint:80 ubuntu@$instance
