output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "asg_name" {
  value = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "keypair_name" {
  value = aws_key_pair.this.key_name
}