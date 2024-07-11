# This file provides the values for all the variables declared in
# variables.tf
# Most of the variables in variables.tf have default values, but 
# those default values will be ignored if you provide your own values
# in this file.


# ===================== AWS Credentials ===========================
user_credentials = {
    access_key = "PROVIDE_YOUR_ACCESS_KEY_HERE"
    secret_key = "PROVIDE_YOUR_SECRET_KEY_HERE"
}


# ===================== Cluster and VPC Configuration =============
cluster_config = {
    name                = "twtr-cluster"
    region              = "us-east-2"
    vpc                 = {
        name            = "twtr-vpc"
        network_cidr    = "10.0.0.0/16"
        public_01_cidr  = "10.0.0.0/24"
        public_02_cidr  = "10.0.10.0/24"
        public_03_cidr  = "10.0.20.0/24"
        route_cidr      = "0.0.0.0/0"
    }
}


# ===================== IAM Configuration =========================
task_execution_role_name   = "ecsTaskExecutionRole"


# ===================== Autoscale Configuration ===================
cluster_max_instances      = 2
cluster_min_instances      = 1
cluster_desired_capacity   = 1

# ===================== Target Group Configuration ================

# The database target group will use MongoDB database server
# The port, protocol values are as per MongoDB server requirements
database_target_group       = {
    name                    = "database-target-group"
    port                    = 27017
    protocol                = "TCP"
    target_type             = "ip"
    health_check_path       = null
}

# The backend target group will use Flask framework (python)
# The port, protocol values are as per Python server requirements
backend_target_group        = {
    name                    = "backend-target-group"
    port                    = 5000
    protocol                = "HTTP"
    target_type             = "ip"
    health_check_path       = "/doc"
}

# The frontend target group will use React framework (javascript)
# The port, protocol values are as per Nginx server requirements
frontend_target_group       = {
    name                    = "frontend-target-group"
    port                    = 80
    protocol                = "HTTP"
    target_type             = "ip"
    health_check_path       = "/"
}


# ===================== Security Group Configuration ==============

# Basic details for the security group
cluster_security_group  = {
    name                = "twtr-security-group"
    desc                = "Security group for ECS cluster"
}

# Inbound ports for database target group
security_group_database_ingress = {
    external_port = 27017
    internal_port = 27017
    cidr_blocks   = ["0.0.0.0/0"]
}

# Inbound ports for backend target group
security_group_backend_ingress  = {
    external_port               = 5000
    internal_port               = 5000
    cidr_blocks                 = ["0.0.0.0/0"]
}

# Inbound ports for frontend target group
security_group_frontend_ingress = {
    external_port               = 80
    internal_port               = 80
    cidr_blocks                 = ["0.0.0.0/0"]
}

# Outbound ports for all target groups
security_group_egress   = {
    external_port       = 0
    internal_port       = 0
    cidr_blocks         = ["0.0.0.0/0"]
}


# ===================== Load Balancer Configuration ===============

# Network Load Balancer
twtr_network_lb     = {
    name            = "twtr-network-lb"
    lb_type         = "network"
}

# Network Load Balancer Listener
twtr_network_lb_listener = {
    port                 = 27017
    protocol             = "TCP"
}

# Application Load Balancer
twtr_application_lb = {
    name            = "twtr-application-lb"
    lb_type         = "application"
}

# Listener for Application Load Balancer
twtr_application_lb_listener = {
    port                = 80
    protocol            = "HTTP"
}

# Attach rules to the listener of the Application Load Balancer
twtr_application_lb_listener_rule = {
    priority            = 1
    path_patterns       = [
        "/login",
        "/doc",
        "/tweet*",
        "/mock-tweets",
        "/purge-db"
    ]
}


# ===================== CloudWatch Logs Configuration =====================

# Log driver to use 
log_driver          = "awslogs"

# Prefix for the log streams in the log groups 
logstream_prefix    = "ecs"

# Log group for the database service
database_log_group  = {
    name            = "database-log-group"
    retain_for_days = 7
}

# Log group for the backend service
backend_log_group   = {
    name            = "backend-log-group"
    retain_for_days = 7
}

# Log group for the frontend service
frontend_log_group  = {
    name            = "frontend-log-group"
    retain_for_days = 7
}


# ===================== Task Definition Configuration =====================

# Instance type
instance_type   = ["FARGATE"]

# Networking mode for instance (This project will rely on AWS Fargate)
network_mode    = "awsvpc"

# Database task definition
database_task_definition    = {
    family                  = "database-task-definition"
    cpu                     = "1024"
    memory                  = "3072"
    container_name          = "database_container"
    container_image         = "PROVIDE_YOUR_DATABASE_IMAGE_URL_HERE"
    container_importance    = true
    env                     = {
        url_prefix       = "mongodb://"
    }
    port_config             = {
        container_port      = 27017
        protocol            = "tcp"
    }
}

# Backend task definition
backend_task_definition     = {
    family                  = "backend-task-definition"
    cpu                     = "1024"
    memory                  = "3072"
    container_name          = "backend_container"
    container_image         = "PROVIDE_YOUR_BACKEND_IMAGE_URL_HERE"
    container_importance    = true
    port_config             = {
        container_port      = 5000
        protocol            = "tcp"
    }
}

# Frontend task definition
frontend_task_definition    = {
    family                  = "frontend-task-definition"
    cpu                     = "1024"
    memory                  = "3072"
    container_name          = "frontend_container"
    container_image         = "PROVIDE_YOUR_FRONTEND_IMAGE_URL_HERE"
    container_importance    = true
    env                     = {
        be_url_prefix       = "http://"
    }
    port_config             = {
        container_port      = 80
        protocol            = "tcp"
    }
}


# ===================== Services Configuration =====================

# Controller to handle deployment of services
deployment_controller       = "ECS"

# Database service
database_service            = {
    name                    = "database-service"
    desired_instances       = 1
    instance_type           = "FARGATE"
    network_config          = {
        allot_public_ip     = true
    }
}

# Backend service
backend_service             = {
    name                    = "backend-service"
    desired_instances       = 1
    instance_type           = "FARGATE"
    network_config          = {
        allot_public_ip     = true
    }
}

# Frontend service
frontend_service            = {
    name                    = "frontend-service"
    desired_instances       = 1
    instance_type           = "FARGATE"
    network_config          = {
        allot_public_ip     = true
    }
}