import logging
import boto3
import os 
logger = logging.getLogger()
logger.setLevel(logging.INFO)
region=os.environ.get('REGION')
ec2 = boto3.client('ec2', region_name=region)

def getInstancesToStop():
    instances = ['i-02fb51f59a615784f']
    return instances
def getInstancesToStart():
    instances = ['i-02fb51f59a615784f']
    return instances
def setInstances(instances):
    list_instances=instances
    for instance in list_instances:
        logger.info ("instance à traiter "+instance)
def startInstances():
    list_instances=getInstancesToStart()
    response_json=ec2.start_instances(InstanceIds=list_instances)
    logger.info('started your instances: ' + str(list_instances))
    return response_json
def stopInstances():
    list_instances=getInstancesToStop()
    response_json=ec2.stop_instances(InstanceIds=list_instances)
    logger.info('stopped your instances: ' + str(list_instances))
    return response_json