part of pythonChannel;

class PythonMethodException {
  int code;
  String message;
  String details;
  PythonMethodException({
    required this.code,
    required this.message,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'code': code});
    result.addAll({'message': message});
    result.addAll({'details': details});

    return result;
  }

  factory PythonMethodException.fromMap(Map<String, dynamic> map) {
    return PythonMethodException(
      code: map['code']?.toInt() ?? 0,
      message: map['message'] ?? '',
      details: map['details'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PythonMethodException.fromJson(String source) =>
      PythonMethodException.fromMap(json.decode(source));

  @override
  String toString() =>
      'PythonMethodException(code: $code, message: $message, details: $details)';
}
