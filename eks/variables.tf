variable "vpc_name"{
    default = "eks-vpc"
} 

variable "vpc_cidr"{
    default     = "10.0.0.0/16"
    description = "Default CIDR range of the VPC"
}

variable "kubernetes_version"{
    default = "1.33"
}
variable "cluster_name"{
    default = "eks-cluster"
}

# variable "aws_region"{
#     default = "eu-west-1"
# }

variable "instance_type"{
default = "t3.medium"
}

variable "environment" {
    default = "dev"
  
}

variable "primary_region" {
  type        = string
  description = "AWS region for the primary cluster"
}

variable "dr_region" {
  type        = string
  description = "AWS region for the DR cluster"
}

variable "velero_chart_version" {
  type        = string
  description = "Helm chart version for Velero"
}

variable "create_primary_cluster" {
  type        = bool
  description = "Toggle to create the Primary EKS Cluster"
  default     = true
}

variable "create_dr_cluster" {
  type        = bool
  description = "Toggle to create the DR EKS Cluster"
  default     = true
}