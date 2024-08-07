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
  family                   = "${var.project_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_params.cpu
  memory                   = var.ecs_params.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([
	{
	  name      = "${var.ecs_params.container_name}"
	  image     = "${var.ecs_params.container_image_url}:latest"
	  essential = true
	  portMappings = [
		{
		  containerPort = var.ecs_params.container_port
		  hostPort      = var.ecs_params.container_port
		}
	  ]
	}
  ])
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
      },
      Action = "sts:AssumeRole"
	  }
	]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "ecs_task_execution_policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}

resource "aws_iam_policy_attachment" "ecr_access_policy" {
  name       = "ecr_access_policy"
  policy_arn = aws_iam_policy.ecr_access_policy.arn
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_iam_policy" "ecr_access_policy" {
  name        = "ECRAccessPolicy"
  description = "Policy to allow ECS tasks to access ECR"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "${var.project_name}-${var.environment}-ecs-task-execution-policy"
  description = "Policy for ECS Task Execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      }
    ]
  })
}
################################################################################
# ECS Service
################################################################################
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task.arn
  desired_count   = var.ecs_params.desired_capacity #1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    assign_public_ip = true
    security_groups = [var.security_group_id]
  }
}