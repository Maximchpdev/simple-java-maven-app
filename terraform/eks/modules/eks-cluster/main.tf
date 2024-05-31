################################################################################
# EKS Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "tf-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  create_kms_key              = false
  create_cloudwatch_log_group = false
  cluster_encryption_config   = {}

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    
    //aws-ebs-csi-driver = {
    //  most_recent = true
    //}
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.micro"]
    disk_size = 8
    
    //iam_role_additional_policies = {
    //  AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    //}
    
  }
  
  eks_managed_node_groups = {
    prod = {
      name = "node-group-1"

      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
      
          labels = {
        role = "prod"
      }
    }

    dev = {
      name = "node-group-2"

      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
      
          labels = {
        role = "dev"
      }
    }
  }

  //# aws-auth configmap
  //manage_aws_auth_configmap = true
  //#create_aws_auth_configmap = true

  //aws_auth_roles = [
  //  {
  //   rolearn  = var.rolearn
  //    username = "cluster_operations"
  //    groups   = ["system:masters"]
  //  },
  //]

  tags = {
    env       = "dev"
    terraform = "true"
  }
}

