# Paid test capacity is opt-in. Always Free remains the default.
variable "compute_profile" {
  type    = string
  default = "always-free-arm"
  validation {
    condition     = contains(["always-free-arm", "credit-minimal-amd64"], var.compute_profile)
    error_message = "Select always-free-arm or the explicitly authorized credit-minimal-amd64 test profile."
  }
}
variable "stop_at_utc" {
  type    = string
  default = ""
  validation {
    condition     = var.stop_at_utc == "" || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", var.stop_at_utc))
    error_message = "Use an exact UTC stop time (YYYY-MM-DDTHH:MM:SSZ) for a credit test."
  }
}
locals {
  credit_test = var.compute_profile == "credit-minimal-amd64"
  profiles = {
    always-free-arm      = { shape = "VM.Standard.A1.Flex", ocpus = 2, memory = 12 }
    credit-minimal-amd64 = { shape = "VM.Standard.E5.Flex", ocpus = 1, memory = 8 }
  }
  compute            = local.profiles[var.compute_profile]
  target_compartment = local.credit_test ? oci_identity_compartment.credit_test[0].id : var.compartment_ocid
}

# The scheduler receives power/read access only in this otherwise empty test compartment.
resource "oci_identity_compartment" "credit_test" {
  count          = local.credit_test ? 1 : 0
  compartment_id = var.compartment_ocid
  name           = var.deployment_id
  description    = "Isolated minimal commerce credit test"
  freeform_tags  = local.tags
  enable_delete  = false
  lifecycle { prevent_destroy = true }
}
resource "oci_resource_scheduler_schedule" "credit_stop" {
  count              = local.credit_test ? 1 : 0
  compartment_id     = local.target_compartment
  display_name       = "${var.deployment_id}-stop"
  description        = "Stop the single test instance at the chosen UTC deadline; retry hourly for one day."
  action             = "STOP_RESOURCE"
  recurrence_type    = "ICAL"
  recurrence_details = "FREQ=HOURLY;INTERVAL=1"
  time_starts        = var.stop_at_utc
  time_ends          = timeadd(var.stop_at_utc, "24h")
  state              = "ACTIVE"
  resources { id = oci_core_instance.platform.id }
  freeform_tags = local.tags
  lifecycle { prevent_destroy = true }
}
resource "oci_identity_policy" "credit_stop" {
  count          = local.credit_test ? 1 : 0
  compartment_id = local.target_compartment
  name           = "${var.deployment_id}-stop"
  description    = "Only the owned schedule may read/power the isolated test instance."
  statements = [
    "Allow any-user to {INSTANCE_READ, INSTANCE_POWER_ACTIONS} in compartment id ${local.target_compartment} where all {request.principal.type='resourceschedule', request.principal.id='${oci_resource_scheduler_schedule.credit_stop[0].id}'}"
  ]
  freeform_tags = local.tags
  lifecycle { prevent_destroy = true }
}
output "compute_profile" { value = var.compute_profile }
output "resource_compartment_id" { value = local.target_compartment }
output "stop_at_utc" { value = var.stop_at_utc }
output "stop_schedule_id" { value = local.credit_test ? oci_resource_scheduler_schedule.credit_stop[0].id : "" }
output "stop_policy_id" { value = local.credit_test ? oci_identity_policy.credit_stop[0].id : "" }
