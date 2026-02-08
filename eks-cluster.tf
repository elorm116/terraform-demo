provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.myapp-eks-cluster.token
}

data "aws_eks_cluster_auth" "myapp-eks-cluster" {
  name = module.eks.cluster_name
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" 

  name    = var.cluster_name
  kubernetes_version = var.kubernetes_version

  addons = {
  coredns                = {}
  eks-pod-identity-agent = {
    before_compute = true
    }
  kube-proxy             = {}
  vpc-cni                = {
    before_compute = true
    }
  }
  
  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true


  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    worker_group_1 = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    environment = var.environment
    application = var.application
  }
}