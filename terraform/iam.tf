# Create a Task Execution Role for ECS on AWS IAM
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name                = var.task_execution_role_name
  assume_role_policy  = jsonencode({
    Version           = "2012-10-17",
    Statement         = [{
      Effect          = "Allow",
      Principal       = {
        Service       = "ecs-tasks.amazonaws.com"
      },
      Action          = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRolePolicy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}