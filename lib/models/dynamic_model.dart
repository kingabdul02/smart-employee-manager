class DynamicModel {
  final Map<String, dynamic> data;
  DynamicModel([Map<String, dynamic>? data]) : data = data ?? {};
  factory DynamicModel.fromJson(Map<String, dynamic> json) {
    return DynamicModel(json);
  }
  Map<String, dynamic> toJson() {
    return data;
  }

  T? get<T>(String key) {
    return data[key] as T?;
  }

  void set<T>(String key, T value) {
    data[key] = value;
  }
}
