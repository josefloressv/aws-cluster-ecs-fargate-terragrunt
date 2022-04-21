terraform {
    source = "${get_env("HOME")}/today/aws-cluster-ecs-fargate-terraform//"
}

remote_state {
    backend = "s3"
    config = {
        bucket = "terraform-state-0421-testing"
        key = "cluster/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-dynamo-0421-testing"
    }
}

inputs = {
    # Cluster
    cluster_name = "TestingFargateCluster"
    base_tags = {
        env         = "Testing"
        createdFrom = "terraform"
    }
    cluster_tags = {
        Name         = "TestingFargateCluster"
    }
    
    # VPC
    vpc_name = "TestingFargateVPC"
    vpc_cidr = "192.168.0.0/16"
    vpc_public_subnets = ["192.168.1.0/24", "192.168.2.0/24"]
    vpc_public_subnets_azs= ["us-east-1a", "us-east-1b"]
    vpc_tags = {
        Name         = "TestingFargateVPC"
    }

    # Security Group
    sg_alb_name = "TestingFargateSGALB"
    sg_alb_ingress = [
        {
            description = "Allow port HTTP"
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

        }, {
            description = "Allow port 3000 for static IP access test"
            from_port   = 3000
            to_port     = 3000
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

        }
    ]

    sg_alb_tags = {
        Name = "TestingFargateSGALB"
        Info = "Allow HTTP traffic from anywhere"
    }

    # Load Balancer
    alb_name = "TestingFargateALB"
    alb_subnets = ["us-east-1a", "us-east-1b"]
    alb_tags = {
        Name = "TestingFargateALB"
    }

    alb_default_listener_status_code = "404"
    alb_default_listener_message = "Sorry, the page Not Found :/ att: the LB"
}
