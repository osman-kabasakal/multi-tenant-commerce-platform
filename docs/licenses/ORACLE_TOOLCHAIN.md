# Optional Oracle operator toolchain

Checked 2026-10-17. These are independently installed operator tools, not bundled binaries or part of the application image. Repository publication and asset clearance remain governed by [the main license review](../LICENSE_REVIEW.md).

| Tool | Exact tested version | Upstream license evidence |
| --- | --- | --- |
| Terraform CLI | 1.5.7; Oracle Resource Manager stack selects 1.5.x | [Version-specific MPL-2.0 text](https://github.com/hashicorp/terraform/blob/v1.5.7/LICENSE) |
| Oracle Terraform provider | 7.23.0; pinned in main.tf and .terraform.lock.hcl | [Version-specific MPL-2.0 text](https://github.com/oracle/terraform-provider-oci/blob/v7.23.0/LICENSE.txt) |
| OCI CLI | 3.95.0 | [Version-specific UPL-1.0 or Apache-2.0 choice and third-party notices](https://github.com/oracle/oci-cli/blob/v3.95.0/LICENSE.txt) |

The infrastructure ZIP contains the repository's Terraform source, public cloud-init configuration and dependency lock metadata. It does not contain Terraform/OCI executables or their downloaded dependencies. No terms are inferred for other versions. Cloud service pricing, account limits and image eligibility are separate from these tool licenses.
