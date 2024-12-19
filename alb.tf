resource "aws_lb" "network" {

  name               = "naveen-network-loadbalncer"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  tags = {
    Name = "${var.vpc_name}-loadbalancer"
  }
}

resource "aws_lb_target_group" "ram" {
  name     = "naveen-target"
  port     = 8080
  protocol = "TCP"
  vpc_id   = aws_vpc.dev.id
  health_check {
    interval            = 30
    protocol            = "TCP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    
  }
  tags = {
    Name = "${var.vpc_name}-target"
  }

}



resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.network.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ram.arn
  }

}