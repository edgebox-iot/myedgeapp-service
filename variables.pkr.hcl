variable "digitalocean_api_token" {
  type =  string
  default = "your_token_here"
  sensitive = true
}

variable "system_pw" {
  type =  string
  default = "your_pw_here"
  sensitive = true
}

variable "network_prefix" {
  type =  string
  default = "10.10.10.1"
}

variable "bootnode_ip" {
  type =  string
  default = ""
}

variable "bootnode_token" {
  type =  string
  default = ""
  sensitive = true
}