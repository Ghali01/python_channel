part of pythonChannel;

class ArgsMethodCallException implements Exception {
  @override
  String toString() {
    return '$runtimeType: args souhld be Map<String,dynamic> or List<dynamic>';
  }
}
