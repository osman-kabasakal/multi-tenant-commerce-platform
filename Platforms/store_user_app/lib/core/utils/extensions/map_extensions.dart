extension MapExtensions on Map {
  Map<String, dynamic> toDynamicMap() {
    return Map<String, dynamic>.from(map(((key, value) =>
        MapEntry(key.toString(), MapExtensions.foldDynamicMap(value)))));
  }

  static dynamic foldDynamicMap(dynamic value) {
    if (value is Map) {
      return value.toDynamicMap();
    } else if (value is List) {
      return value.map((v) => MapExtensions.foldDynamicMap(v)).toList();
    } else {
      return value;
    }
  }
}
