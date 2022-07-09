variable "prefix" {
  description = "The prefix used for all resources in this example"
}

variable "region" {
  description = "The Azure location where all resources in this example should be created"
}

variable "publisher" {
  description = "Publisher of the image used to create VM"
}
variable "offer" {
  description = "Offer of the image used to create VM"
}
variable "sku" {
  description = "SKU of the image used to create VM"
}
variable "_version" {
  description = "Version of the image used to create VM, underscore added to avoid Terraform error"
}

variable "cloudshell_public_ip" {
  description = "This IP added into ssh allow list for bastion VM"
  type = string
  default = "12.34.56.78"
}