# Create an ECS cluster

resource "aws_ecs_cluster" "tf_ecs_cluster" {
    name = var.cluster_config.name
}