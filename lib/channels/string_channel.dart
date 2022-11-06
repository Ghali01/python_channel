part of pythonChannel;

/// This class present chanell that send and recive String
class StringChannel extends Channel<String, String> {
  StringChannel({required super.name});

  @override
  Uint8List decodeInput(String data) {
    return Uint8List.fromList(utf8.encode(data));
  }

  @override
  Uint8List decodeOutput(String data) {
    return Uint8List.fromList(utf8.encode(data));
  }

  @override
  String encodeInput(Uint8List data) {
    return utf8.decode(data);
  }

  @override
  String encodeOutput(Uint8List data) {
    return utf8.decode(data);
  }
}
