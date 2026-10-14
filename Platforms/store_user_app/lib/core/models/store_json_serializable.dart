abstract class StoreJsonSerializable<T> {
  const StoreJsonSerializable();

  factory StoreJsonSerializable.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson();
}
