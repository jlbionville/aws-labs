#!/usr/bin/env python3
import boto3
import json
import os
import uuid
from datetime import datetime

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def handler(event, context):
    data = json.loads(event["body"])
    item = {
        "id": str(uuid.uuid4()),
        "url": data["url"],
        "title": data["title"],
        "createdAt": datetime.utcnow().isoformat()
    }
    table.put_item(Item=item)
    return {"statusCode": 201, "body": json.dumps(item)}
