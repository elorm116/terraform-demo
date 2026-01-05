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

  name    = "myapp-eks-cluster"
  kubernetes_version = "1.34" 

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
    }

    worker_group_2 = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
    }
  }

  tags = {
    environment = "dev"
    application = "myapp"
  }
}