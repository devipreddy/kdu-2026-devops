terraform {
  backend "s3" {
    bucket         = "devi-prasad-terraform-state"
    key            = "assignment-2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "devi-prasad-terraform-lock"
    encrypt        = true
  }
}