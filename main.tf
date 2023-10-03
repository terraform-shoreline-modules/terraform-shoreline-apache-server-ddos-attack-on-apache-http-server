terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "ddos_attack_on_apache_http_server" {
  source    = "./modules/ddos_attack_on_apache_http_server"

  providers = {
    shoreline = shoreline
  }
}