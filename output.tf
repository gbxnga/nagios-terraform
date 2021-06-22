output "instance_ip" {
    value = "${aws_instance.nagios_instance.public_ip}"
}