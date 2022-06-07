# Get EC2 Security Group

instanceId="i-0534f4c10d6187a0c" # Enter instance ID
awsQuery="Reservations[].Instances[].{SecurityGroups:SecurityGroups}[0]"
aws  ec2 describe-instances --instance-ids "$instanceId" --query "$awsQuery"| jq -r  '.SecurityGroups[0].GroupId'

