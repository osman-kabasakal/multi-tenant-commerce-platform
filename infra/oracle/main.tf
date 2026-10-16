terraform {
  required_version = "~> 1.5.0"
  required_providers {
    oci = { source = "oracle/oci", version = "7.23.0" }
  }
}

# Resource Manager supplies provider credentials. Never put application secrets here.
provider "oci" { region = var.region }

variable "region" { type = string }
variable "compartment_ocid" { type = string }
variable "availability_domain" { type = string }
variable "image_ocid" {
  type        = string
  description = "Pinned official Always Free eligible Canonical Ubuntu 24.04 ARM64 image in this home region."
}
variable "deployment_id" {
  type = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,39}$", var.deployment_id))
    error_message = "Use a unique deployment ID: 3-40 lowercase letters, digits or hyphens."
  }
}
variable "ssh_public_key" {
  type = string
  validation {
    condition     = can(regex("^ssh-ed25519 [A-Za-z0-9+/=]+( [^\\r\\n]+)?$", var.ssh_public_key))
    error_message = "Supply only an Ed25519 public key, never a private key."
  }
}
variable "ssh_source_cidr" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.ssh_source_cidr)) && can(regex("/32$", var.ssh_source_cidr))
    error_message = "Restrict SSH to your operator/CI public IPv4 address with /32."
  }
}

locals {
  tags = { "commerce-deployment" = var.deployment_id }
}

resource "oci_core_vcn" "platform" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = ["10.42.0.0/16"]
  display_name   = var.deployment_id
  dns_label      = "commerce"
  freeform_tags  = local.tags
  lifecycle { prevent_destroy = true }
}
resource "oci_core_internet_gateway" "platform" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.platform.id
  enabled        = true
  freeform_tags  = local.tags
  lifecycle { prevent_destroy = true }
}
resource "oci_core_route_table" "platform" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.platform.id
  freeform_tags  = local.tags
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.platform.id
  }
  lifecycle { prevent_destroy = true }
}
resource "oci_core_security_list" "platform" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.platform.id
  freeform_tags  = local.tags
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = var.ssh_source_cidr
    tcp_options {
      min = 22
      max = 22
    }
  }
  dynamic "ingress_security_rules" {
    for_each = toset([80, 443])
    content {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }
  # Path MTU discovery, not public database/application ports.
  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"
    icmp_options {
      type = 3
      code = 4
    }
  }
  lifecycle { prevent_destroy = true }
}
resource "oci_core_subnet" "platform" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.platform.id
  cidr_block        = "10.42.1.0/24"
  dns_label         = "platform"
  route_table_id    = oci_core_route_table.platform.id
  security_list_ids = [oci_core_security_list.platform.id]
  freeform_tags     = local.tags
  lifecycle { prevent_destroy = true }
}
resource "oci_core_instance" "platform" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = var.deployment_id
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }
  source_details {
    source_type             = "image"
    source_id               = var.image_ocid
    boot_volume_size_in_gbs = 100
    boot_volume_vpus_per_gb = 10
  }
  create_vnic_details {
    subnet_id        = oci_core_subnet.platform.id
    assign_public_ip = true
    hostname_label   = "commerce"
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("${path.module}/cloud-init.yaml"))
  }
  preserve_boot_volume = true
  freeform_tags        = local.tags
  lifecycle { prevent_destroy = true }
}

output "instance_id" { value = oci_core_instance.platform.id }
output "public_ip" { value = oci_core_instance.platform.public_ip }
output "deployment_id" { value = var.deployment_id }
