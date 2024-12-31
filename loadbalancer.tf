resource "aws_lb" "myloadbalancer" {
  name                       = "myapplication"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.allow_tls.id]
  subnets                    = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  enable_deletion_protection = true
}

resource "aws_lb_target_group" "grocery" {
  name     = "grocery-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path     = "/"
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group" "fashion" {
  name     = "fashion-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path     = "/fashion/"
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group" "mobile" {
  name     = "mobile-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path     = "/mobile/"
    port     = 80
    protocol = "HTTP"
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.myloadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grocery.arn
  }
}

resource "aws_lb_listener_rule" "fashionapp" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fashion.arn
  }
  condition {
    path_pattern {
      values = ["/fashion*"]
    }
  }
}

resource "aws_lb_listener_rule" "mobileapp" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mobile.arn
  }
  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }
}

