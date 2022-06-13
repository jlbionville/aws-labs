import logging
import boto3
import os 
logger = logging.getLogger()
logger.setLevel(logging.INFO)
region=os.environ.get('REGION')
ec2 = boto3.client('ec2', region_name=region)

def startInstance(instanceId):
    
    response_json=ec2.start_instances(InstanceIds=[instanceId])
    logger.info('started the instances: ' + instanceId)
    return response_json
def stopInstances(instanceId):
    
    response_json=ec2.stop_instances(InstanceIds=[instanceId])
    logger.info('stopped the instance: ' + instanceId)
    return response_json

def validateUploadFileInBucket(fileChecksum, bucketObjectKey):
    logger.info('file in bucket to check: ' + bucketObjectKey)
    logger.info('Checksum of th file in bucket to check: ' + fileChecksum)