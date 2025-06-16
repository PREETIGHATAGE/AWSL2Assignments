import boto3
import datetime

s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']

    if not file_key.endswith('.txt') or not file_key.startswith('out/'):
        return

    local_file = '/tmp/input.txt'
    s3.download_file(bucket, file_key, local_file)

    with open(local_file, 'r') as f:
        count = len(f.read().split())

    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    result_line = f"{timestamp} | {file_key} | Word Count: {count}\n"

    count_file = '/tmp/count.txt'
    try:
        s3.download_file(bucket, 'count/count.txt', count_file)
    except:
        open(count_file, 'w').close()

    with open(count_file, 'a') as f:
        f.write(result_line)

    s3.upload_file(count_file, bucket, 'count/count.txt')
