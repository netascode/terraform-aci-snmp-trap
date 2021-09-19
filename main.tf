resource "aci_rest" "snmpGroup" {
  dn         = "uni/fabric/snmpgroup-${var.name}"
  class_name = "snmpGroup"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest" "snmpTrapDest" {
  for_each   = { for dest in var.destinations : dest.hostname_ip => dest }
  dn         = "${aci_rest.snmpGroup.id}/trapdest-${each.value.hostname_ip}-port-${each.value.port != null ? each.value.port : 162}"
  class_name = "snmpTrapDest"
  content = {
    host     = each.value.hostname_ip
    port     = each.value.port != null ? each.value.port : 162
    secName  = each.value.community
    v3SecLvl = each.value.security != null ? each.value.security : "noauth"
    ver      = each.value.version != null ? each.value.version : "v2c"
  }
}

resource "aci_rest" "fileRsARemoteHostToEpg" {
  for_each   = { for dest in var.destinations : dest.hostname_ip => dest if dest.mgmt_epg != null && dest.mgmt_epg_name != null }
  dn         = "${aci_rest.snmpTrapDest[each.value.hostname_ip].id}/rsARemoteHostToEpg"
  class_name = "fileRsARemoteHostToEpg"
  content = {
    tDn = each.value.mgmt_epg == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${each.value.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${each.value.mgmt_epg_name}"
  }
}
