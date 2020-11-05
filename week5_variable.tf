
# variables.tf
variable "region" {
  default = "eu-west-2"
}
variable "availabilityZone1" {
  default = "eu-west-2a"
}
variable "availabilityZone2" {
  default = "eu-west-2b"
}
variable "availabilityZone3" {
  default = "eu-west-2c"
}

variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = "10.9.0.0/16"
}
variable "subnetCIDRblock1" {
  default = "10.9.4.0/24"
}
variable "subnetCIDRblock2" {
  default = "10.9.2.0/24"
}
variable "subnetCIDRblock3" {
  default = "10.9.3.0/24"
}

variable "subnetCIDRblock4" {
  default = "10.9.5.0/24"
}

variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type    = list
  default = ["0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type    = list
  default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}
# end of variables.tf