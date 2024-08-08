################################################################################
# ECS Cluster
################################################################################
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

################################################################################
# Fargate Task Definition
################################################################################
resource "aws_ecs_task_definition" "fargate_task" {
  family                   = "${var.project_name}-${var.environment}-${var.ecs_params.app_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_params.cpu
  memory                   = var.ecs_params.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([
	{
	  name      = "${var.ecs_params.container_name}"
	  image     = "${var.container_image_url}:latest"
	  essential = true
	  portMappings = [
		{
		  containerPort = var.ecs_params.container_port
		  hostPort      = var.ecs_params.container_port
		}
	  ]
	}
  ])
	# network_configuration {
	# 	subnets         = var.subnet_ids
	# 	assign_public_ip = true
	# }
}

################################################################################
# IAM Role for ECS Task Execution
################################################################################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
	Version = "2012-10-17"
	Statement = [
	  {
		Action = "sts:AssumeRole"
		Effect = "Allow"
		Principal = {
		  Service = "ecs-tasks.amazonaws.com"
		}
	  }
	]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_execution_ecr_policy" {
  name   = "${var.project_name}-${var.environment}-ecs-task-execution-ecr-policy"
  role   = aws_iam_role.ecs_task_execution_role.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "arn:aws:ecr:${var.region}:${var.account_id}:repository/${var.ecr_repository_name_app}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

################################################################################
# ECS Service
################################################################################
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}-${var.environment}-${var.ecs_params.app_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task.arn
  desired_count   = var.ecs_params.desired_capacity
  launch_type     = "FARGATE"

  network_configuration {
	  subnets         = var.subnet_ids
    security_groups = var.security_groups
	  assign_public_ip = true
  }
}