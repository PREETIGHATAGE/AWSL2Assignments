output "bucket_name" {
    value = aws_s3_bucket.s3_bucket.bucket
}

output "ec2_public_ip" {
    value = [ for instance in aws_instance.ec2 : instance.public_ip]
}