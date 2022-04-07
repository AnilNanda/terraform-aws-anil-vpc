variable "vpc_cidr" {
  type = string
  description = "Vpc CIDR block."
}

# variable "subnet_cidr" {
#   type = map(object(
#       {
#           cidr_block = string,
#           availability_zone = string
#       }
#   ))
# }