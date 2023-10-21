variable "vpc-sg-ids" {
    type =list(string)
  
}

variable "db-subnet-db_subnet_group_name" {
    type = string

}

variable "engine_type" {
    type = string
    default ="postgres"
  
}

variable "engine_ver"{
    type = string
    default = "15"

}

variable "db_user" {
    type = string
  
}

variable "db_password" {
    type = string
  
}

variable "APP_NAME" {
    type = string
  
}
variable "database_name" {
    type = string
  
}
