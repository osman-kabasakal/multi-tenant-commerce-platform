abstract class JsonConverter<T, TToJsonTip> {
  TToJsonTip toJson(T value);
  T fromJson(TToJsonTip json);
}
