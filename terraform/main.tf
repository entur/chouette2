# Terraform configuration for chouette2
# https://github.com/entur/terraform-google-init/tree/master/modules/init#inputs
module "init" {
  source      = "github.com/entur/terraform-google-init//modules/init?ref=v0.3.0"
  app_id      = "chouette" # app id is intintally chouette to deploy chouette2 in same projece as chouette.
  environment = var.env
}

# https://github.com/entur/terraform-google-memorystore/tree/master/modules/redis#inputs
module "redis" {
  source = "github.com/entur/terraform-google-memorystore//modules/redis?ref=v0.1.0"
  init   = module.init
}
