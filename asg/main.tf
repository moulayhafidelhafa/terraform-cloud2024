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

resource "aws_autoscaling_notification" "slack_notifications" {
  group_names = data.aws_autoscaling_groups.groups.names

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = "TOPIC ARN"
}