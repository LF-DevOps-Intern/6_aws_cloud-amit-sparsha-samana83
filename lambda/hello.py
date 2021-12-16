import json
def handler(event,context):
    
    response={"Hello":"Default"}
    
    return {
    'statusCode': 200,
	'headers': {'Content-Type': 'application/json'},
    'body': json.dumps(response)
    } 

