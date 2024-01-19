#Enviroment variables
variable "env" {
  description = "Environment. dev|tst|prd."
}

variable "kube_namespace" {
  description = "The Kubernetes namespace"
  default = "chouette"
}


variable "ror-chouette2-db-username" {
  description = "chouette2 database username"
}

variable "ror-chouette2-db-password" {
  description = "chouette2 database password"
}

variable "ror-chouette2-secret-key-base" {
  description = "chouette2 secret key base"
}

variable "ror-chouette2-devise-secret-key" {
  description = "chouette2 devise secret key"
}

