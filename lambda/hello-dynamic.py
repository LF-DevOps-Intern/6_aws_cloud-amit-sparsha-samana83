import json

def handler(event,context):
    
    response={"Hello":None}
    
    #extracting the dynamic path from the event passed by API Gateway inserting it in the repsonse.
    response["Hello"]=event["rawPath"].strip('/')

    return {
    'statusCode': 200,
    'body': json.dumps(response)
    } 

