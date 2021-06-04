resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  depends_on   = [aws_lb_target_group.main]
  listener_arn = aws_lb_listener.lb_listener-4141.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }
  condition {
    host_header {
      values = ["atlantis.jmvbxx.com"]
    }
  }
}

resource "aws_lb_target_group" "main" {
  name     = "tf-main-lb-tg"
  port     = 4141
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.server.id
  port             = 4141
}
