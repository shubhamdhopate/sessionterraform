variable "public_cidr_block" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zone" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "private_cidr_block" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "image_id" {
  type    = string
  default = "ami-036841078a4b68e14"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "awscloudblitz"
}