variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/21"
  
}
variable rds_port {
    type = number
    default = 5432
}
variable "public_subnets_cidr_blocks"{
    type = list(string)
    default = [ "10.0.0.0/24","10.0.1.0/24" ]
}
variable "availability_zone" {
    type = list(string)
    default = [ "eu-north-1a","eu-north-1b" ]
  
}
   
variable "private_subnets_cidr_blocks" {
    type = list(string)
    default = ["10.0.4.0/24"]
  
}


variable "create_web_ssh_sg" {
    type = bool
    default = false
  
}

variable "create_db_sg" {
    type = bool
    default = false
  
}

variable "APP_NAME" {
    type = string
}