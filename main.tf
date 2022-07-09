terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.0.4"
  cloud {
    organization = "AWS_POC"

    workspaces {
      name = "AWS_SB_Deployment"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = "ap-south-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "app_server" {
  count                  = 1
  ami                    = "ami-08df646e18b182346"
  instance_type          = "t2.micro"
  key_name               = data.aws_key_pair.example.key_name
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  provisioner "file" {
    source      = "staging"
    destination = "/tmp/staging"
  } 
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install java-1.8.0-openjdk",
      "cd /tmp/staging",
      "java -jar terraformclouddeployment-0.0.1-SNAPSHOT.jar"
    ]
  }
  tags = {
    Name = "Ec2-With-TerraformCloud"
  }
  connection {
    type    = "ssh"
    host    = self.public_ip
    port	= 22
    user    = "ec2-user"
    timeout = "2m"
    agent 	= false
    private_key = var.private_key
  }

}

data "aws_security_group" "selected" {
  name = "launch-wizard-1"
}

data "aws_key_pair" "example" {
  key_name           = "SBDeployment"
}
