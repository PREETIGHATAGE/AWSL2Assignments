variable "region" {
    description = "The AWS region"
    type = string
    default = "us-east-1"
}

variable "instance_type" {
    description = "The type of instance"
    type = string
    default = "t2.micro"
}

variable "bucket_name" {
    description = "The Name of S3 bucket"
    type = string
    default = "case-study4-s3"
}

variable "ami_id" {
    description = "The AWS region"
    type = string
    default = "ami-0fc5d935ebf8bc3bc"
}