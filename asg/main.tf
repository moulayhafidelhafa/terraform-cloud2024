resource "aws_launch_configuration" "example" {
  name_prefix   = "example-lc-"
  image_id      = "ami-06c68f701d8090592"  # Replace with your desired AMI ID
  instance_type = "t2.micro"      # Replace with your desired instance type
  security_groups = ["sg-02c26dd0ad2146582"]  # Replace with your security group ID
  key_name      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuZbQqYqxFcS6K7MayN09ZD88IpRikIwkxAIltO8x6xi4bBZvazYZ4XWf4eL3MEtgsknehZz14yzFSW7LyJ2Zzyd9ir1GXKuLXw3qwZYV+XwYttWYbXmksJmm1isUEpXFrQ9VfGlEfjB6fqoV3RxNl53gPXSssjyA3HjTOjkHi/wxK/UKs5pgvk/ZM6DKxFzZ8B4jAq3/Wc+7tET2JX2QhWRBibPa+V7q/3fCjGV2N3p2BAeqq2uaW5X9O+tyO4gGJBM9qEouelJYRRE4Mbw6tABQ6NaMLSH1rgbSneC/A95EVXqqS4W+56slJFkDK0D86pd0BBoAggcIY/TLfaUdLxdcgOvirmMgQgUd7cJsQ7Lvadw/onJiz+RUjJMmxDuO1cZyrOdCtEcFYdu4kchYow6HkZb3G4tp9Ew1Y3cZ/ADj16ZV3uqEEzlynY1kQKoFR/J3ZJ0lF7w9NsyInpFvgOBC+12VBduSUrPzdqBvfr+sraYKrSk4PB3XBPk0KxrU= cloudshell-user@ip-10-136-35-208.ec2.internal"  # Replace with your key pair name

  # Optional: User data script
  # user_data = filebase64("path/to/userdata.sh")

  lifecycle {
    create_before_destroy = true
  }
}

# Define the Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  name_prefix                 = "example-asg-"
  launch_configuration        = aws_launch_configuration.example.id
  vpc_zone_identifier         = ["subnet-12345678", "subnet-23456789"]  # Replace with your subnet IDs
  min_size                    = 2   # Minimum number of instances
  max_size                    = 5   # Maximum number of instances
  desired_capacity            = 3   # Desired number of instances
  health_check_type           = "EC2"
  health_check_grace_period   = 300  # 5 minutes

  # Optional: Load balancer configuration
  # target_group_arns           = ["arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-targets/73e2d6bc24d8a067"]

  # Optional: Tags
  tags = [
    {
      key                 = "Name"
      value               = "example-asg"
      propagate_at_launch = true
    },
  ]
}

# Optional: Define Scaling Policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1  # Increase instance count by 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300  # 5 minutes cooldown period
  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1  # Decrease instance count by 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300  # 5 minutes cooldown period
  autoscaling_group_name = aws_autoscaling_group.example.name
}
