data "aws_autoscaling_groups" "groups" {
  filter {
    name   = "tag:Team"
    values = ["Pets"]
  }

  filter {
    name   = "tag-key"
    values = ["Environment"]
  }
}

}