#!/usr/bin/env python3
import boto3
import json
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def handler(event, context):
    bookmark_id = event["pathParameters"]["id"]
    table.delete_item(Key={"id": bookmark_id})
    return {"statusCode": 204}
