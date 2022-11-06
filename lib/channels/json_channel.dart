part of pythonChannel;

/// This class present chanell that send and recive json [Map] or [List]
class JsonChannel extends Channel<Object, Object> {
  JsonChannel({required super.name});

  @override
  Uint8List decodeInput(Object data) {
    String json = jsonEncode(data);
    return Uint8List.fromList(utf8.encode(json));
  }

  @override
  Uint8List decodeOutput(Object data) {
    String json = jsonEncode(data);
    return Uint8List.fromList(utf8.encode(json));
  }

  @override
  Object encodeInput(Uint8List data) {
    String json = utf8.decode(data);
    return jsonDecode(json);
  }

  @override
  Object encodeOutput(Uint8List data) {
    String json = utf8.decode(data);
    return jsonDecode(json);
  }
}
