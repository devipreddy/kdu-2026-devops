terraform {
  backend "s3" {
    bucket         = "devi-three-tier-dev-tf-state"
    key            = "assignment-2/dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "devi-three-tier-dev-tf-locks"
  }
}