import json

def terraport_main(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Terraport!')
    }
