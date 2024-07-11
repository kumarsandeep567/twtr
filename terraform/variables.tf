# ===================== AWS Credentials =====================
variable "user_credentials" {
    description = "Please provide the access key and secret key to connect to AWS"
}

# ===================== Cluster and VPC Configuration =====================
variable "cluster_config" {
    description = <<-EOT
        Define the AWS ECS cluster with the required configuration,
        along with the Virtual Private Cloud (VPC) configuration.
    EOT
}

# ===================== IAM Configuration =====================
variable "task_execution_role_name" {
    type        = string
    description = "The task execution role that will be used within ECS cluster"
    default     = "tfEcsTaskExecutionRole"
    nullable    = false
}


# ===================== Autoscale Configuration =====================
variable "cluster_max_instances" { 
    description = "Maximum number of instances in the ECS cluster" 
    default = 1
}

variable "cluster_min_instances" { 
    description = "Minimum number of instances in the ECS cluster" 
    default = 1
}

variable "cluster_desired_capacity" { 
    description = "Desired number of instances in the ECS cluster" 
    default = 1
}


# ===================== Target Group Configuration =====================

# Backend Target Groups
variable "database_target_group" {
    description = "Setup the target groups for the MongoDB database service"
}

# Backend Target Groups
variable "backend_target_group" {
    description = "Setup the target groups for the Flask backend service"
}

# Frontend Target Groups
variable "frontend_target_group" {
    description = "Setup the target groups for the React frontend service"
}


# ===================== Security Group Configuration ==========
variable "cluster_security_group" {
    type        = object({
        name    = string
        desc    = string
        vpc_id  = string
    })
    description = "Security Group for the ECS cluster"
}

variable "security_group_database_ingress" {
    description = "Enable ports (with port forwarding) for the database target group to handle incoming traffic"
}

variable "security_group_backend_ingress" {
    description = "Enable ports (with port forwarding) for the backend target group to handle incoming traffic"
}

variable "security_group_frontend_ingress" {
    description = "Enable ports (with port forwarding) for the frontend target group to handle incoming traffic"
}

variable "security_group_egress" {
    description = "Enable ports for all target groups to handle outgoing traffic"
}


# ===================== Load Balancer Configuration =====================

# Network Load Balancer
variable "twtr_network_lb" {
    description = "Network Load Balancer will be used to handle the traffic for the database target groups"
}

# Listener for Network Load Balancer
variable "twtr_network_lb_listener" {
    description = "Listener for the Network Load Balancer"
}

# Application Load Balancer
variable "twtr_application_lb" {
    description = "Application Load Balancer will be used to handle the traffic for the frontend and backend target groups"
}

# Listener for Application Load Balancer
variable "twtr_application_lb_listener" {
    description = "Listener for the Application Load Balancer"
}

# Attach rules to the listener of the Application Load Balancer
variable "twtr_application_lb_listener_rule" {
    description = "Rule for the Listener of the Application Load Balancer"
}


# ===================== CloudWatch Logs Configuration =====================

# Log driver to use 
variable "log_driver" {
    type        = string
    description = "The log driver to use to interact with the logs"
    default     = "awslogs"
}

# Prefix for the log groups 
variable "logstream_prefix" {
    type        = string
    description = "The prefix to use for the log groups on CloudWatch"
    default     = "ecs"
}

# Log group for the database service
variable "database_log_group" {
    type        = object({
        name            = string
        retain_for_days = number
    })
    description = "Create and use the CloudWatch log group for logging activities in the database service"
}

# Log group for the backend service
variable "backend_log_group" {
    type        = object({
        name            = string
        retain_for_days = number
    })
    description = "Create and use the CloudWatch log group for logging activities in the backend service"
}

# Log group for the frontend service
variable "frontend_log_group" {
    type        = object({
        name            = string
        retain_for_days = number
    })
    description = "Create and use the CloudWatch log group for logging activities in the frontend service"
}


# ===================== Task Definition Configuration =====================

# Instance type
variable "instance_type" {
    description = "List of instance types the project requires"
}


# Networking mode for instance (This project will rely on AWS Fargate)
variable "network_mode" {
    description = "Choose the networking mode that the AWS instance will use"
}


# Database task definition
variable "database_task_definition" {
    description = "Create the task definition for the database service"
}


# Backend task definition
variable "backend_task_definition" {
    description = "Create the task definition for the backend service" 
}

# Frontend task definition
variable "frontend_task_definition" {
    description = "Create the task definition for the frontend service"
}


# ===================== Services Configuration =====================

# Deployment controller
variable "deployment_controller" {
    type        = string
    description = "Specify the AWS ECS deployment controller"
    default     = "ECS"
}

# Database service
variable "database_service" {
    description = "Create and start the database service (with specified load balancer)"
}

# Backend service
variable "backend_service" {
    description = "Create and start the backend service (with specified load balancer)"
}

# Frontend service
variable "frontend_service" {
    description = "Create and start the frontend service (with specified load balancer)"
}