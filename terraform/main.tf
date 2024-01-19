# Terraform configuration for chouette2
# https://github.com/entur/terraform-google-init/tree/master/modules/init#inputs
module "init" {
  source      = "github.com/entur/terraform-google-init//modules/init?ref=v0.3.0"
  app_id      = "chouette"  # app id is intintally chouette to deploy chouette2 in same projece as chouette.
  environment = var.env
}

# https://github.com/entur/terraform-google-memorystore/tree/master/modules/redis#inputs
module "redis" {
  source = "github.com/entur/terraform-google-memorystore//modules/redis?ref=v0.1.0"
  init   = module.init
}



resource "kubernetes_secret" "ror-chouette2-secret" {
  metadata {
    name      = "ror-chouette2-secret"
    namespace = var.kube_namespace
  }

  data = {
    "secret_key_base" = var.ror-chouette2-secret-key-base
    "devise_secret_key" = var.ror-chouette2-devise-secret-key
    "chouette2_db_username" = var.ror-chouette2-db-username
    "chouette2_db_password" = var.ror-chouette2-db-password
  }
}
