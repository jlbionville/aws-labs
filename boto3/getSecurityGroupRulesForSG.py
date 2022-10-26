import boto3
import os
region=os.environ.get('AWS_REGION')
ec2=boto3.client('ec2', region_name=region)
response = ec2.describe_security_group_rules(
    Filters=[
        {
            'Name': 'group-id',
            'Values': [
                'sg-0b3a2825fccbd9139'
            ]
        },
    ]
)
print(response["SecurityGroupRules"])

for rule in response["SecurityGroupRules"]:
    print(rule["SecurityGroupRuleId"])