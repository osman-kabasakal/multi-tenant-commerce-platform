/// Public build identity; native Firebase resources must belong to this tenant.
class TenantFirebaseIdentity {
  const TenantFirebaseIdentity({
    required this.tenantId,
    required this.packageName,
    required this.projectId,
    required this.projectNumber,
    required this.appId,
  });

  final String tenantId;
  final String packageName;
  final String projectId;
  final String projectNumber;
  final String appId;

  void verify({
    required String nativePackageName,
    required String nativeProjectId,
    required String nativeProjectNumber,
    required String nativeAppId,
    required String platform,
  }) {
    if (!RegExp(r'^[a-f0-9]{32}$').hasMatch(tenantId) ||
        tenantId == '00000000000000000000000000000000' ||
        !RegExp(r'^[a-z][a-z0-9-]{4,28}[a-z0-9]$').hasMatch(projectId) ||
        !RegExp(r'^[1-9][0-9]*$').hasMatch(projectNumber) ||
        !RegExp(
          r'^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+$',
        ).hasMatch(packageName) ||
        (platform != 'android' && platform != 'ios') ||
        !RegExp('^1:$projectNumber:$platform:[A-Za-z0-9]+\$').hasMatch(appId) ||
        nativePackageName != packageName ||
        nativeProjectId != projectId ||
        nativeProjectNumber != projectNumber ||
        nativeAppId != appId) {
      throw StateError(
        'Native Firebase identity does not match this tenant build.',
      );
    }
  }
}
