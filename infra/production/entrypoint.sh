#!/bin/sh
set -eu
role="${1:-help}"
if [ "$#" -gt 0 ]; then shift; fi
case "$role" in
  commerce) cd /app/commerce; set -- dotnet Grand.Web.MultiTenant.dll "$@" ;;
  admin) cd /app/admin; set -- dotnet Grand.Web.OnlyAdmin.dll "$@" ;;
  gateway) cd /app/gateway; set -- dotnet Platform.Gateway.dll "$@" ;;
  saas) cd /app/saas; set -- dotnet SaasManager.Web.dll "$@" ;;
  worker) cd /app/worker; set -- dotnet TenantManager.dll --provisioning-worker "$@" ;;
  mail-worker) cd /app/worker; set -- dotnet TenantManager.dll --readiness-email-worker "$@" ;;
  task-worker) cd /app/worker; set -- dotnet TenantManager.dll --tenant-schedule-worker "$@" ;;
  cloud) cd /app/cloud; set -- dotnet Platform.Cloud.dll "$@" ;;
  bootstrap) cd /app/bootstrap; set -- dotnet Platform.Bootstrap.dll "$@" ;;
  help) printf '%s\n' 'Roles: commerce admin gateway saas worker mail-worker task-worker bootstrap cloud'; exit 0 ;;
  *) printf '%s\n' 'Unknown platform role.' >&2; exit 64 ;;
esac
exec "$@"
