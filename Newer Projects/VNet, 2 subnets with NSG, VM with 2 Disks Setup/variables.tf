variable "vm_name" {
    type = string
    description = "Name of virtual machine"
  
}

variable "admin_username" {
    type = string
    description = "admin username for VM"
  
}

variable "admin_password" {
    type = string
    description = "admin password for VM"
  
}

variable "vm_size" {
    type = string
    description = "size of the VM"
    default = "Standard_B1ls"
}
