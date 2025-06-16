import boto3
import os

ec2 = boto3.client('ec2')
instance_id = os.environ['INSTANCE_ID']

def lambda_handler(event, context):
    action = event.get("ACTION", os.environ.get("ACTION"))
    print(f"Recieved ACTION: {action}")
    print(f"Target Instance: {instance_id}")
    if action == "start":
        ec2.start_instances(InstanceIds=[instance_id])
        print("EC2 Instance started")
    elif action == "stop":
        ec2.stop_instances(InstanceIds=[instance_id])
        print("EC2 Instance stopped")
    else:
        print("Invalid action. Please specify 'start' or 'stop'.")
