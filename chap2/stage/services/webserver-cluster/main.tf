provider aws{
  region="us-west-2"
}

resource aws_instance "example"{
  ami="ami-0571c1aedb4b8c5fc"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
	            #!/bin/bash
				echo "Hello World" > index.html
                nohup busybox httpd -f -p 8080 & 
				EOF
  user_data_replace_on_change = true
    	
  tags = {
    Name ="terraform-example"
	}

}

resource "aws_security_group" "instance"{
  name = "terraform-example-instance"
  
  ingress {
    from_port = 8080
	to_port = 8080
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "terraform_state"{
  bucket = "terraform-up-and-running-stateamu"
  lifecycle {
  #prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled"{
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration{
    status = "Enabled"
  }
    
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default"{
  bucket = aws_s3_bucket.terraform_state.id
  rule{
    apply_server_side_encryption_by_default{
	  sse_algorithm ="AES256"
	}
  }
}

resource "aws_s3_bucket_public_access_block" "public_access"{
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform-locks"{
  name = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
   name = "LockID"
   type ="S"
  }
}

terraform {
  backend "s3"{
    bucket = "terraform-up-and-running-stateamu"
	key = "global/s3/terraform.tfstate"
	region = "us-west-2"
	
	dynamodb_table = "terraform-up-and-running-locks"
	encrypt = true
  }
}

output "s3_bucket_arn"{
  value = aws_s3_bucket.terraform_state.arn
  description = "State of S3 bucket"
}

output "dynamodb_table_name"{
  value = aws_dynamodb_table.terraform-locks.name
  description ="dynamodb_table_name"
}


