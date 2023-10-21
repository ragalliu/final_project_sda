variable "min_nodes_number" {
    type = number
    default = 1
  
}

variable "max_nodes_number" {
    type = number
    default = 3
}

variable "preferd_nodes_number" {
    type = number
    default = 2
  
}
variable "kubernetes_version" {
    type = string
    default = "1.27"
  
}
variable "cluster_subnet_ids" {
    type = list(string)
  
}

variable "APP_NAME" {
    type = string
  
}

