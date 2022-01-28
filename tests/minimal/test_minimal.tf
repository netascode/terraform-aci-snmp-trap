terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."

  name = "TRAP1"
}

data "aci_rest_managed" "snmpGroup" {
  dn = "uni/fabric/snmpgroup-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "snmpGroup" {
  component = "snmpGroup"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.snmpGroup.content.name
    want        = module.main.name
  }
}
