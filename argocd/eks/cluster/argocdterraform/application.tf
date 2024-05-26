
module "argocd_application" {
  source = "git::https://github.com/project-octal/terraform-kubernetes-argocd-application.git?ref=50d4a0205efc06269a0c5453572743a5d720edbd"
  argocd_namespace    = "argocd"
  destination_server  = "https://kubernetes.default.svc"
  project             = "default"
  name                = "app"
  namespace           = "default"
  repo_url            = "https://gitlab.com/guyedrix2/wello.git"
  chart               = ""
  path                = "combined-charts/mongodb"
  target_revision     = "HEAD"
  automated_self_heal = true
  automated_prune     = true
  labels              = {
      app = "app"
  }
}
# module "argocd_application" {
#   source = "git::https://github.com/project-octal/terraform-kubernetes-argocd-application.git?ref=50d4a0205efc06269a0c5453572743a5d720edbd"
#   # source  = "project-octal/argocd-application/kubernetes"
#   # version = "~> 2.0.1"

#   argocd_namespace    = "argocd"
#   destination_server  = "https://kubernetes.default.svc"
#   project             = "default"  # module.project.name
#   name                = "hailyeah"
#   namespace           = "default"
#   repo_url            = "https://github.com/Gilibee-goode/Hailyeah-ArgoCD.git"
#   path                = "Helm"
#   chart               = ""
#   target_revision     = "HEAD"
# #   helm_parameters =  [  # another option to update the image that Argo uses
# #     {
# #         name: "weatherAppImage.tag"
# #         value: var.app_image
# #         force_string: true
# #     }

# #   ]
# #   helm_values         = {
# #       helm_values = "go-here"
# #   }
#   automated_self_heal = true
#   automated_prune     = true
# #   labels              = {
# #       custom = "lables-to-apply"
# #   }
#   depends_on = [ helm_release.argocd ]
# }
