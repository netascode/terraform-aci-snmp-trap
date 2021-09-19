terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

module "main" {
  source = "../.."

  name = "TRAP1"
}

data "aci_rest" "snmpGroup" {
  dn = "uni/fabric/snmpgroup-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "snmpGroup" {
  component = "snmpGroup"

  equal "name" {
    description = "name"
    got         = data.aci_rest.snmpGroup.content.name
    want        = module.main.name
  }
}
