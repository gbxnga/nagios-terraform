variable "AWS_PROFILE" {
   type = string
}

variable "AWS_REGION" {
   type = string
   default = "eu-west-1"
}

variable "AMIS" {
    type = map(string)
    default = {
        // eu-west-1 = "ami-0ffea00000f287d30"
        eu-west-1 = "ami-08bac620dc84221eb" // Ubuntu 20
        // eu-west-1 = "ami-0943382e114f188e8" // ubuntu 18
    }
}  

variable "PATH_TO_PRIVATE_KEY" {
    default = "keys/mykey"
}   

variable "PATH_TO_PUBLIC_KEY" {
    default = "keys/mykey.pub"
}

variable "INSTANCE_USERNAME" {
    default = "ubuntu"
}