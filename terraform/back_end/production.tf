terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state"      # S3 bucket for states (pre-created)
    key            = "projectX/dev/terraform.tfstate"  # Path/key for this env’s state file
    region         = "us-west-2"                      # AWS region of the bucket
    encrypt        = true
    dynamodb_table = "mycompany-terraform-locks"      # DynamoDB table for locks (pre-created)
  }
}
