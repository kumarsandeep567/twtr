# Create a new security group for the ECS cluster

# Since the application will have 3 services listening on
# different ports, 3 inbound rules for incoming traffic will
# be required. 
# Only 1 rule for outgoing traffic is needed.

resource "aws_security_group" "cluster_security_group" {

    # Basic details
    name        = var.cluster_security_group.name
    description = var.cluster_security_group.desc
    vpc_id      = aws_vpc.cluster_vpc.id

    # Open up incoming ports for the database target group
    ingress {
        from_port   = var.security_group_database_ingress.external_port
        to_port     = var.security_group_database_ingress.internal_port
        protocol    = "TCP"
        cidr_blocks = var.security_group_database_ingress.cidr_blocks
    }

    # Open up incoming ports for the backend target group
    ingress {
        from_port   = var.security_group_backend_ingress.external_port
        to_port     = var.security_group_backend_ingress.internal_port
        protocol    = "TCP"
        cidr_blocks = var.security_group_backend_ingress.cidr_blocks
    }

    # Open up incoming ports for the frontend target group
    ingress {
        from_port   = var.security_group_frontend_ingress.external_port
        to_port     = var.security_group_frontend_ingress.internal_port
        protocol    = "TCP"
        cidr_blocks = var.security_group_frontend_ingress.cidr_blocks
    }

    # Open up outgoing ports for all target groups
    egress {
        from_port   = var.security_group_egress.external_port
        to_port     = var.security_group_egress.internal_port
        protocol    = "-1"
        cidr_blocks = var.security_group_egress.cidr_blocks
    }
}