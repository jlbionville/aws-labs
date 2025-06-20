#!/usr/bin/env python3
import boto3
import json
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def handler(event, context):
    bookmark_id = event["pathParameters"]["id"]
    response = table.get_item(Key={"id": bookmark_id})
    item = response.get("Item")
    if item:
        return {"statusCode": 200, "body": json.dumps(item)}
    return {"statusCode": 404, "body": json.dumps({"error": "Not found"})}
