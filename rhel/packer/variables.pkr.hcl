# Installation media
variable "iso_path" {
  type        = string
  description = "Path to boot ISO file"
}

variable "iso_checksum_type" {
  type        = string
  description = "Algorithm used to compute the ISO checksum"
  default     = "sha256"
}

variable "iso_checksum_value" {
  type        = string
  description = "ISO checksum value"
}

# Red Hat system registration
variable "rhel_register_system" {
  type        = bool
  description = "Is registration necessary for installation ?"
  default     = false
}

variable "rhel_org" {
  type        = string
  description = "Red Hat organisation"
  sensitive   = true
}

variable "rhel_activation_key" {
  type        = string
  description = "Red Hat activation key"
  sensitive   = true
}

# Disk
variable "disk_name" {
  type        = string
  description = "Name used to construct the disk file name"
}

variable "disk_size" {
  type        = number
  description = "Disk size in Gigabytes"
}

variable "disk_output_directory" {
  type        = string
  description = "Directory in which the disk image will be created"
}

# Installation parameters
variable "install_headless" {
  type        = bool
  description = "Set to false to follow the installation in the VM console"
  default     = true
}

variable "install_ks_path" {
  type        = string
  description = "Path to the installation Kickstart file"
}
