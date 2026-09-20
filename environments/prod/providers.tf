provider "aws" {
  region  = "us-east-1"
  profile = "urban-devops"

  default_tags {
    tags = {
      Project     = "urban-fantasy-devops"
      Environment = "prod"
      ManagedBy   = "terraform"
    }
  }
}