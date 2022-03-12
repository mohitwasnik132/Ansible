##|||||||||||||||||||||||-=-AMI ID and REGION out-=-|||||||||||||||||||||||||||||||#
 output "region" {
   value = data.aws_region.current
 }

 output "os" {
   value = [aws_instance.instance.ami, var.ami_name]
 }