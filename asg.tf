module "asg_integrate_cloudwatch_grafana" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 5.0.0"

  name = "asg-integrate-cloudwatch-grafana"

  lt_name   = "example-asg-lc-icg"
  use_lt    = true
  create_lt = true

  image_id        = "ami-0574da719dca65348"
  instance_type   = "t2.micro"
  security_groups = ["sg-abcdef"]

  key_name = var.key_name

  iam_instance_profile_arn = var.iam_instance_profile_arn # create role for cloudwatch (full access)

  user_data_base64 = filebase64("cloudwatch-agent/script.sh")

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 25
        volume_type           = "gp3"
      }
    }
  ]

  # Auto scaling group
  vpc_zone_identifier       = ["subnet-abcdef"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 4
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
}