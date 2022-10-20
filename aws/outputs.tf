output "ec2_global_ips" {
  value = ["${aws_instance.search_engine.*.public_ip}"]
}
