part of pythonChannel;

/// class represent method call through [MethodChannel]
class MethodCall {
  String method;
  late Object args;
  MethodCall({required this.method, required Object args}) {
    if (!(args is List || args is Map<String, dynamic>)) {
      throw ArgsMethodCallException();
    }
    // ignore: prefer_initializing_formals
    this.args = args;
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'method': method});
    result.addAll({'args': args});

    return result;
  }

  factory MethodCall.fromMap(Map<String, dynamic> map) {
    return MethodCall(
      method: map['method'] ?? '',
      args: map['args'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MethodCall.fromJson(String source) =>
      MethodCall.fromMap(json.decode(source));

  @override
  String toString() => 'MethodCall(method: $method, args: $args)';
}
