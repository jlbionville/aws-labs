#!/usr/bin/env python3
import json

def handler(event, context):
    return {
    "statusCode": 200,
    "body": json.dumps({"message": "pong"})
    }