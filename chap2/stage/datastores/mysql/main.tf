provider "aws" {
  region = "us-west-2"  
}

resource "aws_db_instace" "example"{
  identfier_prefix = "terraform_up_and_running"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "t2.micro"
  skip_final_snapshot = true
  db_name = "example_database"
   username = var.username
   password = var.password


}