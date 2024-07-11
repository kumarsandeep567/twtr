# Create the log groups on CloudWatch

# The application will have 3 services which will derive from
# 3 task definitions respectively. 
# All activities in each service will be logged to its respective
# log group


# Log group for the database service
resource "aws_cloudwatch_log_group" "database_log_group" {
    name                = var.database_log_group.name
    retention_in_days   = var.database_log_group.retain_for_days
}

# Log group for the backend service
resource "aws_cloudwatch_log_group" "backend_log_group" {
    name                = var.backend_log_group.name
    retention_in_days   = var.backend_log_group.retain_for_days
}

# Log group for the frontend service
resource "aws_cloudwatch_log_group" "frontend_log_group" {
    name                = var.frontend_log_group.name
    retention_in_days   = var.frontend_log_group.retain_for_days
}