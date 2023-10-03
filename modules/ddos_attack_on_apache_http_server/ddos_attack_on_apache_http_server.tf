resource "shoreline_notebook" "ddos_attack_on_apache_http_server" {
  name       = "ddos_attack_on_apache_http_server"
  data       = file("${path.module}/data/ddos_attack_on_apache_http_server.json")
  depends_on = [shoreline_action.invoke_apache_rate_limit]
}

resource "shoreline_file" "apache_rate_limit" {
  name             = "apache_rate_limit"
  input_file       = "${path.module}/data/apache_rate_limit.sh"
  md5              = filemd5("${path.module}/data/apache_rate_limit.sh")
  description      = "Implement rate limiting: Implement rate-limiting to limit the number of requests a single IP address can make to the server."
  destination_path = "/agent/scripts/apache_rate_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_apache_rate_limit" {
  name        = "invoke_apache_rate_limit"
  description = "Implement rate limiting: Implement rate-limiting to limit the number of requests a single IP address can make to the server."
  command     = "`chmod +x /agent/scripts/apache_rate_limit.sh && /agent/scripts/apache_rate_limit.sh`"
  params      = ["MAX_CONNECTIONS","RATE_INTERVAL","MAX_REQUESTS"]
  file_deps   = ["apache_rate_limit"]
  enabled     = true
  depends_on  = [shoreline_file.apache_rate_limit]
}

