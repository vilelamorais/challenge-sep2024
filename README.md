#===============================================================================
# Assunto: Configuração do vpc-cni no cluster EKS da AWS
#    Tags: k8s vpc-cni eks aws

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon#example-add-on-usage-with-custom-configuration_values

Como conseguir a configuração do add-on
- https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-versions.html

Configuração do add-on como extra
- https://github.com/aws/amazon-vpc-cni-k8s

- Alguns exemplos de configuraçãoes do cluster com o plugin
  + https://registry.terraform.io/modules/bootlabstech/fully-loaded-eks-cluster/aws/latest
  + https://registry.terraform.io/modules/bootlabstech/fully-loaded-eks-cluster/aws/latest/submodules/aws-vpc-cni
  + https://github.com/bootlabstech/terraform-aws-fully-loaded-eks-cluster/blob/main/modules/kubernetes-addons/aws-vpc-cni/main.tf
  
  + https://medium.com/@john.shaw.zen/eks-terraform-migrate-to-terraform-aws-eks-blueprints-addons-011ff0b195ed
  + https://marcincuber.medium.com/amazon-eks-add-ons-custom-and-advanced-configuration-with-terraform-be745672eedf

  + https://registry.terraform.io/modules/squareops/eks-addons/aws/latest
  + https://registry.terraform.io/modules/squareops/eks-addons/aws/latest/submodules/aws-vpc-cni

#===============================================================================
# Assunto: terraform data
#    Tags: terraform

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets
https://github.com/terraform-aws-modules/terraform-aws-efs/blob/master/examples/complete/README.md
https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/latest