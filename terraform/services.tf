# Create the database, backend, and frontend services 
# based on their task definitions

# Database service (responsible for starting the MongoDB database)
resource "aws_ecs_service" "database_service" {
    name            = var.database_service.name
    cluster         = aws_ecs_cluster.tf_ecs_cluster.id
    task_definition = aws_ecs_task_definition.database_task_definition.arn
    desired_count   = var.database_service.desired_instances
    launch_type     = var.database_service.instance_type

    network_configuration {
        subnets             = [
                                aws_subnet.public_subnet_01.id,
                                aws_subnet.public_subnet_02.id,
                                aws_subnet.public_subnet_03.id
        ]
        security_groups     = [aws_security_group.cluster_security_group.id]
        assign_public_ip    = var.database_service.network_config.allot_public_ip
    }

    load_balancer {
        target_group_arn    = aws_lb_target_group.database_target_group.arn
        container_name      = var.database_task_definition.container_name
        container_port      = var.database_task_definition.port_config.container_port
    }

    deployment_controller {
        type                = var.deployment_controller
    }
}


# Backend service (responsible for starting the Flask backend)
resource "aws_ecs_service" "backend_service" {
    name            = var.backend_service.name
    cluster         = aws_ecs_cluster.tf_ecs_cluster.id
    task_definition = aws_ecs_task_definition.backend_task_definition.arn
    desired_count   = var.backend_service.desired_instances
    launch_type     = var.backend_service.instance_type

    network_configuration {
        subnets             = [
                                aws_subnet.public_subnet_01.id,
                                aws_subnet.public_subnet_02.id,
                                aws_subnet.public_subnet_03.id
        ]
        security_groups     = [aws_security_group.cluster_security_group.id]
        assign_public_ip    = var.backend_service.network_config.allot_public_ip
    }

    load_balancer {
        target_group_arn    = aws_lb_target_group.backend_target_group.arn
        container_name      = var.backend_task_definition.container_name
        container_port      = var.backend_task_definition.port_config.container_port
    }

    deployment_controller {
        type                = var.deployment_controller
    }
}


# Frontend service (responsible for starting the React frontend)
resource "aws_ecs_service" "frontend_service" {
    name            = var.frontend_service.name
    cluster         = aws_ecs_cluster.tf_ecs_cluster.id
    task_definition = aws_ecs_task_definition.frontend_task_definition.arn
    desired_count   = var.frontend_service.desired_instances
    launch_type     = var.frontend_service.instance_type

    network_configuration {
        subnets             = [
                                aws_subnet.public_subnet_01.id,
                                aws_subnet.public_subnet_02.id,
                                aws_subnet.public_subnet_03.id
        ]
        security_groups     = [aws_security_group.cluster_security_group.id]
        assign_public_ip    = var.frontend_service.network_config.allot_public_ip
    }

    load_balancer {
        target_group_arn    = aws_lb_target_group.frontend_target_group.arn
        container_name      = var.frontend_task_definition.container_name
        container_port      = var.frontend_task_definition.port_config.container_port
    }

    deployment_controller {
        type                = var.deployment_controller
    }
}