#!/usr/bin/env python3
import boto3
import json
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def handler(event, context):
    response = table.scan()
    return {
        "statusCode": 200,
        "body": json.dumps(response["Items"])
    }
