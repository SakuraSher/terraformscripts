provider "aws" {
  region = "us-west-2"
}

module webserver_cluster{
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "Isaidso"
}
