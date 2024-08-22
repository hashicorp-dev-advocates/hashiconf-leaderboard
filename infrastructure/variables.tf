variable "name" {
  type        = string
  description = "Name of resources"
  default     = "hashiconf-activations"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "tags" {
  type        = map(string)
  description = "List of tags to add to resources"
  default     = {}
}

variable "client_cidr_blocks" {
  type        = list(string)
  description = "List of clients allowed to connect to bastion for database"
}

variable "postgres_db_version" {
  type        = string
  description = "PostgreSQL database version"
  default     = "16.4"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.small"
  description = "Database instance class"
}

variable "db_name" {
  type        = string
  default     = "leaderboard"
  description = "Name of database"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository to push images"
  default     = "hashicorp-dev-advocates/hashiconf-leaderboard"
}

variable "leaderboard_services" {
  type        = set(string)
  description = "List of services to create ECR repositories"
  default = [
    "frontend",
    "admin",
    "api"
  ]
}