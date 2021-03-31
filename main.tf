terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.7.0"
    }
  }
  required_version = ">= 0.13"
}

provider "bigip" {
  alias    = "f5-1"
  address  = var.f5_ui
  username = var.f5_username
  password = var.f5_password
}

# For testing, write out to local file
resource "local_file" "rendered_as3" {
  content       = templatefile("${path.module}/as3.tpl", {
    virtual_ip    = var.as3vip
    tenant_name   = var.as3tenant
    app_name      = var.as3app
    app_list      = var.app_definition

  })
  filename = "${path.module}/rendered_as3.json"
}

# For testing, write out to file
resource "bigip_as3" "tf_templated_as3" {
  as3_json        = templatefile("${path.module}/as3.tpl", {
    virtual_ip    = var.as3vip
    tenant_name   = var.as3tenant
    app_name      = var.as3app
    app_list      = var.app_definition
  })
  provider        = bigip.f5-1
  tenant_filter   = var.as3tenant
}




