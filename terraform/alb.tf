resource "aws_lb" "main" {
  name               = "atlantis-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_atlantis.id]
  subnets            = [aws_subnet.main.id, aws_subnet.secondary.id]

  enable_deletion_protection = true

  tags = {
    Environment = "atlantis"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    target_group_arn = aws_lb_target_group.atlantis.id
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "example" {
  listener_arn    = aws_lb_listener.lb_listener.arn
  certificate_arn = data.aws_acm_certificate.atlantis_amazon_issued.arn
}

resource "aws_lb_listener_rule" "listener_rule" {
  depends_on   = [aws_lb_target_group.atlantis]
  listener_arn = aws_lb_listener.lb_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.atlantis.id
  }
  condition {
    host_header {
      values = ["atlantis.jmvbxx.com"]
    }
  }
}

resource "aws_lb_target_group" "atlantis" {
  name     = "tf-atlantis-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.atlantis.arn
  target_id        = aws_instance.server.id
  port             = 80
}
