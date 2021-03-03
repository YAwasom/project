resource "aws_lb" "efdwslb" {
  name               = "efd-ecs-${var.efd_env}-ws-ALB"
  internal           = "true"
  load_balancer_type = "network"
  #security_groups    = ["${aws_security_group.efd-ALB-Inbound.id}"]


  enable_deletion_protection = false

  subnet_mapping {
    subnet_id = aws_subnet.private_a.id

  }

  subnet_mapping {
    subnet_id = aws_subnet.private_b.id

  }

  subnet_mapping {
    subnet_id = aws_subnet.private_c.id

  }

  #access_logs {
  #  bucket  = "com-wbts-ask-nonprod-${var.region}-security-archives"
  #  prefix  = "ask-${var.ask_env}-alb"
  #  enabled = true
  #}
}

resource "aws_lb" "efdsurlylb" {
  name               = "efd-ecs-${var.efd_env}-surly-ALB"
  internal           = "false"
  load_balancer_type = "network"
  #security_groups    = ["${aws_security_group.efd-ALB-Inbound.id}"]


  enable_deletion_protection = false

  subnet_mapping {
    subnet_id = aws_subnet.private_a.id

  }
  subnet_mapping {
    subnet_id = aws_subnet.private_b.id

  }

  subnet_mapping {
    subnet_id = aws_subnet.private_c.id

  }

  #access_logs {
  #  bucket  = "com-wbts-ask-nonprod-${var.region}-security-archives"
  #  prefix  = "ask-${var.ask_env}-alb"
  #  enabled = true
  #}
}
resource "aws_lb" "efdblitlinelb" {
  name               = "efd-ecs-${var.efd_env}-blitline-ALB"
  internal           = "false"
  load_balancer_type = "network"
  #security_groups    = ["${aws_security_group.efd-ALB-Inbound.id}"]


  enable_deletion_protection = false

  subnet_mapping {
    subnet_id = aws_subnet.private_a.id

  }
  subnet_mapping {
    subnet_id = aws_subnet.private_b.id

  }

  subnet_mapping {
    subnet_id = aws_subnet.private_c.id

  }

  #access_logs {
  #  bucket  = "com-wbts-ask-nonprod-${var.region}-security-archives"
  #  prefix  = "ask-${var.ask_env}-alb"
  #  enabled = true
  #}
}

resource "aws_lb_target_group" "efdwstg" {
  name                 = "efd-ecs-${var.efd_env}-ws-TG"
  target_type          = "instance"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"
  port                 = "32768"
  protocol             = "TCP"


  health_check {

    interval            = "10"
    unhealthy_threshold = "2"
    healthy_threshold   = "2"
    protocol            = "TCP"
    #path                = "/static-url-ws/services/staticURLService?wsdl"
  }
}


resource "aws_lb_target_group" "efdsurlytg" {
  name                 = "efd-ecs-${var.efd_env}-surly-TG"
  target_type          = "instance"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"
  port                 = "32768"
  protocol             = "TCP"


  health_check {

    interval            = "10"
    unhealthy_threshold = "2"
    healthy_threshold   = "2"
    protocol            = "TCP"
    #path                = "/static-url-ws/services/staticURLService?wsdl"
  }
}

resource "aws_lb_target_group" "efdblitlinetg" {
  name                 = "efd-ecs-${var.efd_env}-blitline-TG"
  target_type          = "instance"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"
  port                 = "32768"
  protocol             = "TCP"


  health_check {

    interval            = "10"
    unhealthy_threshold = "2"
    healthy_threshold   = "2"
    protocol            = "TCP"
    #path                = "/static-url-ws/services/staticURLService?wsdl"
  }
}



resource "aws_lb_listener" "efd-ws-lb-listener" {
  load_balancer_arn = aws_lb.efdwslb.arn
  port              = "80"
  protocol          = "TCP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = aws_acm_certificate.lbcert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.efdwstg.arn

  }
}



resource "aws_lb_listener" "efd-surly-lb-listener" {
  load_balancer_arn = aws_lb.efdsurlylb.arn
  port              = "80"
  protocol          = "TCP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = aws_acm_certificate.lbcert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.efdsurlytg.arn

  }
}

resource "aws_lb_listener" "efd-blitline-lb-listener" {
  load_balancer_arn = aws_lb.efdblitlinelb.arn
  port              = "80"
  protocol          = "TCP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = aws_acm_certificate.lbcert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.efdblitlinetg.arn

  }
}
