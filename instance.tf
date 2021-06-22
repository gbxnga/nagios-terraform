resource "aws_key_pair" "nagios_key_pair" {
    key_name = "my-nagios-key-pair"
    public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "nagios_instance" {
    ami = "${lookup(var.AMIS, var.AWS_REGION)}"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.nagios_key_pair.key_name}"
    security_groups = [aws_security_group.nagios_sg.name]

    provisioner "file" {
        source = "scripts/install-nagios.sh"
        destination = "/tmp/install-nagios.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/install-nagios.sh",
            "sudo /tmp/install-nagios.sh"
        ]
    }

    connection {
      host = self.public_ip
      user = "${var.INSTANCE_USERNAME}"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
    }
}

resource "aws_security_group" "nagios_sg" {
  name = "nagios-sg"
  description = "Web Security Group"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}