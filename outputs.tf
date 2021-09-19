output "dn" {
  value       = aci_rest.snmpGroup.id
  description = "Distinguished name of `snmpGroup` object."
}

output "name" {
  value       = aci_rest.snmpGroup.content.name
  description = "SNMP trap policy name."
}
