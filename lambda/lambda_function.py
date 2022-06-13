import logging
import tools
logger = logging.getLogger()
logger.setLevel(logging.INFO)

list_instances=[]

def lambda_handler(event, context):
    action=event['action']
    instanceId=event['instance']
    bucketObjectKey=event['bucketObjectKey']
    checksumForInstance=event['checksumForInstance']
    logger.info("Event Received:%s", event)
    logger.info("Lambda function ARN:%s", context.invoked_function_arn)
    logger.info("CloudWatch log stream name:%s", context.log_stream_name)
    logger.info("CloudWatch log group name:%s",  context.log_group_name)   
    codeReturnFromInstanceAction={}
    if action=='stop':
        codeReturnFromInstanceAction=tools.stopInstance(instanceId)
    else:
        codeReturnFromInstanceAction=tools.stopInstance(instanceId)
    logger.info(codeReturnFromInstanceAction)
   
    return { 
        'message' : "action done : "+ action,
        'statusCode':200
    }