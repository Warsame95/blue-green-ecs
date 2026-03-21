resource "aws_ecs_cluster" "memos-cluster" {
    name = "${var.app_name}_cluster"

    configuration {
          execute_command_configuration {
            logging    = "DEFAULT"
        }
    }
}
