module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.33"
  endpoint_public_access  = true
  depends_on = [ module.vpc ]
  # The IAM role that Terraform Cloud assumes (OIDC / dynamic credentials / workspace credentials) is not automatically given access to the cluster.
  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  security_group_additional_rules = {
    ingress_bastion_allow = {
      description               = "Allow Bastion host to reach EKS API"
      protocol                  = "tcp"
      from_port                 = 443
      to_port                   = 443
      type                      = "ingress"
      source_security_group_id  = aws_security_group.bastion_sg.id
    }
    }

    access_entries = {
    bastion = {
      principal_arn = aws_iam_role.bastion_ssm.arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }}}

  eks_managed_node_groups = {
    example = {
      instance_types = [var.instance_type]
      ami_type       = "AL2023_x86_64_STANDARD"

      min_size = 2
      max_size = 3
      desired_size = 2
    }
  }

  tags = {
    cluster = var.cluster_name
  }
}


######### EXTRAS ############

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  depends_on = [ module.eks ]
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.1"
  depends_on = [ module.eks, kubernetes_namespace.monitoring]
}
