part of pythonChannel;

class MethodChannel extends Channel<Object, MethodCall> {
  MethodChannel({required super.name});

  @override
  Uint8List decodeInput(MethodCall data) {
    String js = data.toJson();
    return Uint8List.fromList(utf8.encode(js));
  }

  @override
  Uint8List decodeOutput(Object data) {
    Map jsData = {'value': data};
    String js = jsonEncode(jsData);
    return Uint8List.fromList(utf8.encode(js)..insert(0, 0));
  }

  @override
  MethodCall encodeInput(Uint8List data) {
    String js = utf8.decode(data);
    return MethodCall.fromJson(js);
  }

  @override
  Object encodeOutput(Uint8List data) {
    String js = utf8.decode(data.sublist(1));
    Map jsData = jsonDecode(js);
    return jsData['value'];
  }

  PythonMethodException encodeException(Uint8List data) {
    String js = utf8.decode(data.sublist(1));
    return PythonMethodException.fromJson(js);
  }

  Uint8List decodeException(PythonMethodException data) =>
      Uint8List.fromList(utf8.encode(data.toJson()).toList()..insert(0, 1));

  @override
  Future<Object?> send(MethodCall msg) async {
    while (_socket == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    List<int> msgBuffer = [];
    Uint8List id = _genID();
    msgBuffer.addAll(id);
    msgBuffer.add(0);
    msgBuffer.addAll(decodeInput(msg));
    msgBuffer.addAll([0, 0, 0]);
    _socket!.add(msgBuffer);
    _Message reply = await _replyMessages
        .where((event) => event.id == _bytesToInt(id))
        .first;
    switch (reply.data.first) {
      case 1:
        throw encodeException(reply.data);

      default:
        if (reply.data.isNotEmpty) {
          return encodeOutput(reply.data);
        }
    }
  }

  Future<Object?> invokeMethod(String method, Object args) async {
    MethodCall call = MethodCall(method: method, args: args);
    return await send(call);
  }

  @override
  void _startListenOnMsgs() {
    _dataMessages.where((event) => !event.isReply).listen((event) {
      if (_handellr != null) {
        Reply<Object> reply = Reply(msgId: event.id, channel: this);
        try {
          _handellr!(encodeInput(event.data), reply);
        } on PythonMethodException catch (e) {
          _sendException(e, event.id);
        }
      }
    });
  }

  void _sendException(PythonMethodException msg, int id) async {
    List<int> msgBuffer = [];
    msgBuffer.addAll(_intToBytes(id));
    msgBuffer.add(1);
    if (msg != null) {
      msgBuffer.addAll(decodeException(msg));
    }
    msgBuffer.addAll([0, 0, 0]);
    _socket!.add(msgBuffer);
  }
}
