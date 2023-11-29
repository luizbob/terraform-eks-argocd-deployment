locals {
  cluster_subnets = concat(data.aws_subnets.private.ids,data.aws_subnets.public.ids)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = true
  
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
    iam_role_attach_cni_policy = true
  }
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = module.argocd_role.iam_role_arn
      username = "admin"
      groups   = ["system:masters"]
    },
  ]
 
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
  }

  vpc_id                   = data.aws_vpc.production.id
  subnet_ids               = local.cluster_subnets
  eks_managed_node_groups = {
    private = {
      min_size     = var.private_ng_min_size
      max_size     = var.private_ng_max_size
      subnet_ids   = data.aws_subnets.private.ids
      desired_size = 1
      
      tags = var.tags
    }
    public = {
      min_size     = var.public_ng_min_size
      max_size     = var.public_ng_max_size
      desired_size = 1
      subnet_ids   = data.aws_subnets.public.ids
      tags = var.tags
    }
  }
  tags = var.tags
}

## ARGOCD EXTERNAL ROLE##
module "argocd_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.cluster_name}_argocd"

   trusted_role_arns = [
    "arn:aws:iam::123466789123:root" #production account
  ]

}

### ALB INGRESS CONTROLLER ###

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    module.lb_role
  ]

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = data.aws_vpc.production.id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-2.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
}

module "lb_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.cluster_name}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

#### CLUSTER AUTOSCALER ####
module "autoscaler" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${module.eks.cluster_name}_autoscaler"
  attach_cluster_autoscaler_policy = true

  cluster_autoscaler_cluster_names = ["${module.eks.cluster_name}"]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["autoscaler:${module.eks.cluster_name}-autoscaler"]
    }
  }
}

resource "helm_release" "autoscaler" {
  name       = "${module.eks.cluster_name}-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "autoscaler/cluster-autoscaler"
  namespace  = "autoscaler"
  create_namespace = true

  set {
    name  = "autoDiscovery.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.autoscaler.rolearn
  }

}