import boto3
from datetime import datetime, timezone, timedelta

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    cutoff = datetime.now(timezone.utc) - timedelta(days=14)
    snapshots = ec2.describe_snapshots(OwnerIds=['self'])['Snapshots']

    for snap in snapshots:
        if snap['StartTime'] < cutoff:
            ec2.delete_snapshot(SnapshotId=snap['SnapshotId'])
