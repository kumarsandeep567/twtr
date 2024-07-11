# Create the Load Balancers for the ECS cluster.

# Due to the design of the application, 2 load balancers, 
# a Network Load Balancer and an Application Load Balancer,
# are required. The target groups running MongoDB database 
# server will be placed behind the Network Load Balancer, 
# and the target groups running the React frontend and Flask 
# backend will be placed behind the Application Load Balancer.


# ===================== Network Load Balancer =====================

# Network Load Balancer
resource "aws_lb" "twtr_network_lb" {
    name                = var.twtr_network_lb.name
    internal            = false
    load_balancer_type  = var.twtr_network_lb.lb_type
    security_groups     = [aws_security_group.cluster_security_group.id]
    subnets             = [
        aws_subnet.public_subnet_01.id,
        aws_subnet.public_subnet_02.id,
        aws_subnet.public_subnet_03.id
    ]
}

# Listener for Network Load Balancer
resource "aws_lb_listener" "twtr_network_lb_listener" {
    load_balancer_arn    = aws_lb.twtr_network_lb.arn
    port                 = var.twtr_network_lb_listener.port
    protocol             = var.twtr_network_lb_listener.protocol
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.database_target_group.arn
    }
}


# ===================== Application Load Balancer =================

# Application Load Balancer
resource "aws_lb" "twtr_application_lb" {
    name                = var.twtr_application_lb.name
    internal            = false
    load_balancer_type  = var.twtr_application_lb.lb_type
    security_groups     = [aws_security_group.cluster_security_group.id]
    subnets             = [
        aws_subnet.public_subnet_01.id,
        aws_subnet.public_subnet_02.id,
        aws_subnet.public_subnet_03.id
    ]
}

# Listener for Application Load Balancer
resource "aws_lb_listener" "twtr_application_lb_listener" {
    load_balancer_arn    = aws_lb.twtr_application_lb.arn
    port                 = var.twtr_application_lb_listener.port
    protocol             = var.twtr_application_lb_listener.protocol
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.frontend_target_group.arn
    }
}

# Rule for the Application Load Balancer
resource "aws_lb_listener_rule" "forward_to_backend_target_group" {
    listener_arn         = aws_lb_listener.twtr_application_lb_listener.arn
    priority             = var.twtr_application_lb_listener_rule.priority
    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.backend_target_group.arn
    }
    condition {
        path_pattern {
            values       = var.twtr_application_lb_listener_rule.path_patterns
        }
    }
}