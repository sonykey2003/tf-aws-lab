terraform {
  backend "s3" {
    bucket = "your_bucket_name"
    key    = "your_folder//terraform.tfstate"
    region = "your_region"
  }
}