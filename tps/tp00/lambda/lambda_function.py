import logging
import tools
logger = logging.getLogger()
logger.setLevel(logging.INFO)

list_instances=[]

def lambda_handler(event, context):
    action=event['action']
    tools.setInstances(event['instances'])
    logger.info("Lambda function ARN:%s", context.invoked_function_arn)
    logger.info("CloudWatch log stream name:%s", context.log_stream_name)
    logger.info("CloudWatch log group name:%s",  context.log_group_name)   
    
    if action=='stop':
        logger.info(tools.stopInstances())
    else:
        logger.info(tools.startInstances())
   
    return { 
        'message' : "action done : "+ action,
        'statusCode':200
    }