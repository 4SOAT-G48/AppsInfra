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
  cpu                      = var.ecs_params.cpu #"256"
  memory                   = var.ecs_params.memory #"512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([
	{
	  name      = "${var.ecs_params.container_name}"
	  image     = "${var.ecs_params.container_image_url}:latest"
	  essential = true
	  portMappings = [
		{
		  containerPort = var.ecs_params.container_port #80
		  hostPort      = var.ecs_params.container_host_port #80
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
		}
	  }
	]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
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
  }
}