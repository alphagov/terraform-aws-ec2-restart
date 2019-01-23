output "public_ip" {
  value = "${aws_instance.example.*.public_ip}"
}

output "lamdba_log_group" {
  value = "${module.ec2_restart_example.lamdba_log_group}"
}

output "lamdba_log_group_arn" {
  value = "${module.ec2_restart_example.lamdba_log_group_arn}"
}
