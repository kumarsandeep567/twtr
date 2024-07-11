# Create 3 task definitions: 
# 1 for the MongoDB database
# 1 for the Flask backend
# 1 for the React frontend

# Task definition for database
resource "aws_ecs_task_definition" "database_task_definition" {
    family                          = var.database_task_definition.family
    network_mode                    = var.network_mode
    requires_compatibilities        = var.instance_type
    cpu                             = var.database_task_definition.cpu
    memory                          = var.database_task_definition.memory
    execution_role_arn              = aws_iam_role.ecsTaskExecutionRole.arn

    container_definitions           = jsonencode([{
        name                        = var.database_task_definition.container_name
        image                       = var.database_task_definition.container_image
        essential                   = var.database_task_definition.container_importance
        portMappings                = [{
            containerPort           = var.database_task_definition.port_config.container_port
            protocol                = var.database_task_definition.port_config.protocol
        }]
        logConfiguration            = {
            logDriver                   = var.log_driver
            options                     = {
                "awslogs-group"         = var.database_log_group.name
                "awslogs-region"        = var.cluster_config.region
                "awslogs-stream-prefix" = var.logstream_prefix
            }
        }
    }])
}

# Task definition for backend
resource "aws_ecs_task_definition" "backend_task_definition" {
    family                          = var.backend_task_definition.family
    network_mode                    = var.network_mode
    requires_compatibilities        = var.instance_type
    cpu                             = var.backend_task_definition.cpu
    memory                          = var.backend_task_definition.memory
    execution_role_arn              = aws_iam_role.ecsTaskExecutionRole.arn

    container_definitions           = jsonencode([{
        name                        = var.backend_task_definition.container_name
        image                       = var.backend_task_definition.container_image
        essential                   = var.backend_task_definition.container_importance
        portMappings                = [{
            containerPort           = var.backend_task_definition.port_config.container_port
            protocol                = var.backend_task_definition.port_config.protocol
        }]
        environment    = [{
            name             = "DATABASE_URL"
            value            = "${var.database_task_definition.env.url_prefix}${aws_lb.twtr_network_lb.dns_name}:${var.database_task_definition.port_config.container_port}/"
        }]
        logConfiguration            = {
            logDriver                   = var.log_driver
            options                     = {
                "awslogs-group"         = var.backend_log_group.name
                "awslogs-region"        = var.cluster_config.region
                "awslogs-stream-prefix" = var.logstream_prefix
            }
        }
    }])
}

# Task definition for frontend
resource "aws_ecs_task_definition" "frontend_task_definition" {
    family                          = var.frontend_task_definition.family
    network_mode                    = var.network_mode
    requires_compatibilities        = var.instance_type
    cpu                             = var.frontend_task_definition.cpu
    memory                          = var.frontend_task_definition.memory
    execution_role_arn              = aws_iam_role.ecsTaskExecutionRole.arn

    container_definitions           = jsonencode([{
        name                        = var.frontend_task_definition.container_name
        image                       = var.frontend_task_definition.container_image
        essential                   = var.frontend_task_definition.container_importance
        portMappings                = [{
            containerPort           = var.frontend_task_definition.port_config.container_port
            protocol                = var.frontend_task_definition.port_config.protocol
        }]
        environment    = [{
            name             = "REACT_APP_API_SERVICE_URL"
            value            = "${var.frontend_task_definition.env.be_url_prefix}${aws_lb.twtr_application_lb.dns_name}"
        }]
        logConfiguration            = {
            logDriver                   = var.log_driver
            options                     = {
                "awslogs-group"         = var.frontend_log_group.name
                "awslogs-region"        = var.cluster_config.region
                "awslogs-stream-prefix" = var.logstream_prefix
            }
        }
    }])
}