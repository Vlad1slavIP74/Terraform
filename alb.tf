resource "aws_security_group" "alb" {
    name        = "alb_security_group"
    description = "Load balancer security group"
    vpc_id      = "${aws_vpc.default.id}" # тут же я дивлюся свої ім'я там де я оголошую VPC

    ingress {
        # http
        # я його хочу зробити щоб він мав доступ до глобальної мережі
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
        # те що йде на зовні
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create new application load balancer
# я не знаю що передати в subnets 
# в мене ж загальна мережа це 10.0.0.0/16 то її ж треба
# тобто буде ${aws_subnet.default.*.id} файл vpc 2 рядок
resource "aws_alb" "alb" {
    name            = "alb"
    security_groups = ["${aws_security_group.alb.id}"]
    subnets         = ["${aws_subnet.public.*.id}"]

    tags {
        Name        = "example-alb"
    }
}

resource "aws_alb_target_group" "alb_sgroup" {
  name      = "alb-group"
  port      = 80
  protocol  = "HTTP"
  vpc_id    = "${aws_vpc.default.id}"

  health_check {
      healthy_threshold   = 3
      unhealthy_threshold = 10
      timeout             = 20
      interval            = 30
      path                = "/"
      matcher             = "200-202"
  }
}


#The first listener is configured to accept HTTP client connections.

resource "aws_alb_listener" "http_listener" {
    load_balancer_arn = "${aws_alb.alb.arn}"
    port              = 80
    protocol          = "HTTP"

    default_action {
    target_group_arn = "${aws_alb_target_group.alb_group.arn}"
    type             = "forward"
  }
}
