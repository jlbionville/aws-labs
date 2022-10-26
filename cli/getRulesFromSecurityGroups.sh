# Get EC2 Security Group

instanceId="i-0534f4c10d6187a0c" # Enter instance ID
awsQuery="Reservations[].Instances[].{SecurityGroups:SecurityGroups}[0]"
export idSG=`aws  ec2 describe-instances --instance-ids "$instanceId" --query "$awsQuery"| jq -r  '.SecurityGroups[0].GroupId'`
echo $idSG

aws ec2 describe-security-groups --group-ids $idSG

filters='Name="group-id",Values="$idSG" '
echo `aws ec2 describe-security-group-rules --filter $filters`