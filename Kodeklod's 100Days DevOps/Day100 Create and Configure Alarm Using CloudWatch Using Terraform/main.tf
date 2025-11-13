resource "aws_sns_topic" "sns_topic" {
  name = "xfusion-sns-topic"
}

resource "aws_instance" "xfusion-ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "xfusion-ec2"
  }
  
}

resource "aws_cloudwatch_metric_alarm" "xfusion-alarm" {
  alarm_name          = "xfusion-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description = "Triggers if CPU utilization exceeds 90% for 5 minutes"
  alarm_actions = [aws_sns_topic.sns_topic.arn]

    dimensions = {
        InstanceId = aws_instance.xfusion-ec2.id
    }
}