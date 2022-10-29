part of pythonChannel;

class PythonChannelRunError implements Exception {
  String output;
  PythonChannelRunError({
    required this.output,
  });

  @override
  String toString() {
    return '''$runtimeType: got python output on the sthout 
    you should't use print in python code
    output: $output
    ''';
  }
}
