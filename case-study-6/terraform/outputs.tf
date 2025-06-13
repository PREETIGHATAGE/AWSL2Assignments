output "bucket_name" {
    value = aws_s3_bucket.s3_bucket.bucket
}

output "ec2_public_ip" {
    value = aws_instance.ec2.public_ip
}