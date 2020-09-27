provider "aws" {
  version                 = "~> 2.42"
  region                  = "ap-northeast-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "emtg"
}

variable "name" {
  type    = string
  default = "emtg-framework-sci0xxxx"
}

variable "artifacts_name" {
  type    = string
  default = "codepipeline-emtg-framework-sci0xxxx-nifty"
}

variable "environment" {
  type    = string
  default = "emtg-framework-sci0xxxx"
}

variable "vpc_id" {
  description = "ID for the VPC"
  type        = string
  default     = "vpc-a9cff6ce"
}

variable "ami_id" {
  description = "ID for the AMI"
  type        = string
  default     = "ami-0623936ee0d7898a3"
}

variable "sg_groups" {
  type    = set(string)
  default = ["sg-0d8d1a79cc17519b8"]
}

variable "ssh_key" {
  type    = string
  default = "emtg-framework-2020"
}

variable "public_subnet_1a" {
  description = "ID for the Public Subnet 1a"
  type        = string
  default     = "subnet-79fc0631"
}

variable "public_subnet_1c" {
  description = "ID for the Public Subnet 1c"
  type        = string
  default     = "subnet-8b4470d0"
}

# variable "private_subnet_1a" {
#   description = "ID for the Private Subnet 1a"
#   type        = string
#   default     = "subnet-0055a56f9ad41d5ee"
# }

# variable "private_subnet_1c" {
#   description = "ID for the Private Subnet 1c"
#   type        = string
#   default     = "subnet-097b12be67c4627f9"
# }
