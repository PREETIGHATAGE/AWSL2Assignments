resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "case-study4-vpc"
    }
}

resource "aws_subnet" "subnet" {
    count                   = 3
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "case-study4-subnet-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "case-study4-igw"
    }
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "case-study4-rt"
    }
}

resource "aws_route_table_association" "subnet_rt" {
    count          = 3
    subnet_id      = aws_subnet.subnet[count.index].id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = var.bucket_name
    force_destroy  = true
    tags = {
        Name = "case-study4-shareds3"
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
 bucket = aws_s3_bucket.s3_bucket.id
    rule {
        id        = "expire-images"
        status    = "Enabled"

        filter {
            prefix = ""
        }

        expiration {
            days = 30
        }
    }
}
    
resource "aws_s3_bucket_public_access_block" "public_block" {
    bucket = aws_s3_bucket.s3_bucket.id
    block_public_acls       = true 
    block_public_policy     = true
    ignore_public_acls      = true 
    restrict_public_buckets = true
}

resource "aws_iam_role" "s3_access_role" {
    name = "case-study4-ec2-s3-access-role"

    assume_role_policy = jsonencode({
        Version   = "2012-10-17",
        Statement = [
            {
              Effect    = "Allow",
              Principal = {
                Service = "ec2.amazonaws.com"
              },
              Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_policy" "s3_read_policy"  {
    name     = "case-study4-s3-read-access"
    policy   = jsonencode({
        Version    = "2012-10-17"
        Statement  = [{
            Effect   = "Allow",
            Action = [ 
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:*"
                ],
            Resource = [ 
                aws_s3_bucket.s3_bucket.arn,
                "${aws_s3_bucket.s3_bucket.arn}/*" 
            ]
        },
        {
            Effect = "Allow"
            Action = [
                "logs:CreateLogGroup", 
                "logs:CreateLogStream", 
                "logs:PutLogEvents"
            ],
            Resource = "*"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "attach" {
    role       = aws_iam_role.s3_access_role.name
    policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
    bucket =aws_s3_bucket.s3_bucket.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Sid = "AWSCloudTrailAclCheck",
            Effect = "Allow",
            Principal = {
                Service = "cloudtrail.amazonaws.com"
            },
            Action = "s3:GetBucketAcl",
            Resource = "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}"
        },
        {
           Sid = "AWSCloudTrailWrite",
            Effect = "Allow",
            Principal = {
                Service = "cloudtrail.amazonaws.com"
            },
            Action = ["s3:PutObject", "s3:*"]
            Resource = ["${aws_s3_bucket.s3_bucket.arn}",
                        "${aws_s3_bucket.s3_bucket.arn}/*",
                        "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"],
            Condition = {
                StringEquals = {
                    "s3:x-amz-acl" = "bucket-owner-full-control"
                }
            } 
        }]
    })
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "case-study4-ec2-profile"
    role = aws_iam_role.s3_access_role.name
}

resource "aws_security_group" "ec2_sg" {
    vpc_id = aws_vpc.vpc.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "case-study4-sg3"
    }
}

resource "aws_instance" "ec2" {
    count                  = 3
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = "devops"
    subnet_id              = aws_subnet.subnet[count.index].id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
    user_data              = base64encode(templatefile("${path.module}/../scripts/setup.sh", {BUCKET_NAME = var.bucket_name}))
    tags = {
        Name = "case-study4-ec2-instance-${count.index + 1}"
    }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
    vpc_id            = aws_vpc.vpc.id
    service_name      = "com.amazonaws.${var.region}.s3"
    vpc_endpoint_type = "Gateway"
    route_table_ids   = [aws_route_table.route_table.id]
}

resource "aws_iam_policy_attachment" "cloudwatch_agent" {
    name       = "case-study4-cloudwatch-agent"
    roles      = [aws_iam_role.s3_access_role.name]
    policy_arn = "arn:aws:iam::aws:policy/CloudwatchAgentServerPolicy"
}

resource "aws_cloudtrail" "trail" {
    name                          = "case-study4-ec2-activity-trail"
    s3_bucket_name                = aws_s3_bucket.s3_bucket.bucket
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_logging                = true
}