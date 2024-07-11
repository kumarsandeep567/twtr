# Database Target Groups
resource "aws_lb_target_group" "database_target_group" {
    name        = var.database_target_group.name
    port        = var.database_target_group.port
    protocol    = var.database_target_group.protocol
    target_type = var.database_target_group.target_type
    vpc_id      = aws_vpc.cluster_vpc.id
    health_check {
        protocol = var.database_target_group.protocol
        path     = var.database_target_group.health_check_path
    }
}

# Backend Target Groups
resource "aws_lb_target_group" "backend_target_group" {
    name        = var.backend_target_group.name
    port        = var.backend_target_group.port
    protocol    = var.backend_target_group.protocol
    target_type = var.backend_target_group.target_type
    vpc_id      = aws_vpc.cluster_vpc.id
    health_check {
        protocol = var.backend_target_group.protocol
        path     = var.backend_target_group.health_check_path
    }
}

# Frontend Target Groups
resource "aws_lb_target_group" "frontend_target_group" {
    name        = var.frontend_target_group.name
    port        = var.frontend_target_group.port
    protocol    = var.frontend_target_group.protocol
    target_type = var.frontend_target_group.target_type
    vpc_id      = aws_vpc.cluster_vpc.id
    health_check {
        protocol = var.frontend_target_group.protocol
        path     = var.frontend_target_group.health_check_path
    }
}