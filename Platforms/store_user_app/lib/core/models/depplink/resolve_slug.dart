class ResolvedSlug {
  final String entityId;
  final String entityType;
  final String controller;
  final String action;
  final Map<String, String> params;

  ResolvedSlug({
    required this.entityId,
    required this.entityType,
    required this.controller,
    required this.action,
    required this.params,
  });
}