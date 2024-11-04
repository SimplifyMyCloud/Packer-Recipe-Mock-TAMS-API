packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "rocky8" {
  ami_name      = "tams-mock-api-ami-{{timestamp}}"
  instance_type = "t3.2xlarge"
  region        = "us-west-2"

  source_ami_filter {
    filters = {
      name                = "Rocky-8-EC2-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"] # Rocky Linux official owner ID
  }

  ssh_username = "rocky"

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 40
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = "tams-mock-api-example"
    Environment = "development"
    Builder     = "packer"
  }
}

build {
  name    = "tams-mock-api-ami"
  sources = ["source.amazon-ebs.rocky8"]

  provisioner "shell" {
    valid_exit_codes = [
      "0",
      "1",
      "2"
    ]
    script = "configuration-state.sh"
  }
}