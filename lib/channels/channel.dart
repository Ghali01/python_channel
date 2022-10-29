part of pythonChannel;

abstract class Channel<T> {
  String name;
  Socket? _socket;
  late Stream<_Message> _dataMessages;
  late Stream<_Message> _replyMessages;
  void Function(T, Reply<T>)? _handellr;
  Channel({
    required this.name,
  }) {
    _connect().then((value) => null);
    _dataMessages = _listenToDataMessage().asBroadcastStream();
    _dataMessages.where((event) => !event.isReply).listen((event) {
      if (_handellr != null) {
        Reply<T> reply = Reply(msgId: event.id, channel: this);
        _handellr!(encode(event.data), reply);
      }
    });
    _replyMessages =
        _dataMessages.where((event) => event.isReply).asBroadcastStream();
  }
  void setHandeler(void Function(T, Reply) handeler) => _handellr = handeler;

  Future<void> _connect() async {
    while (_Host.port == null) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    _socket = await Socket.connect('127.0.0.1', _Host.port!);
    Uint8List nameMsg = Uint8List.fromList([...utf8.encode(name), 0, 0, 0]);
    _socket!.add(nameMsg);
  }

  int? _checkOnPerfex(List buffer) {
    List zeros = [];
    int i = 0;
    for (var byte in buffer) {
      if (byte == 0) {
        zeros.add(i);
        if (zeros.length == 3) {
          return zeros[0];
        }
      } else {
        zeros.clear();
      }
      i++;
    }
  }

  T encode(Uint8List data);
  Uint8List decode(T data);
  Stream<_Message> _listenToDataMessage() async* {
    while (_socket == null) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    bool connected = true;
    List<int> buffer = [];
    _socket!.listen((data) {
      buffer.addAll(data);
    }, onDone: () => connected = false);
    // print('listing');
    while (connected) {
      int? index = _checkOnPerfex(buffer);
      if (index != null) {
        int msgId = _bytesToInt(Uint8List.fromList(buffer.sublist(0, 4)));
        // print('id reciveved $msgId');

        Uint8List msg = Uint8List.fromList(buffer.sublist(5, index));
        yield _Message(id: msgId, data: msg, isReply: buffer[4] == 1);
        buffer = buffer.sublist(index + 3);
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    print('disconnected');
  }

  Uint8List _intToBytes(int value) {
    List<int> bin = [];
    while (value != 0) {
      bin.add(value % 2);
      value = value ~/ 2;
    }
    bin.addAll(List.filled(32 - bin.length, 0));

    Uint8List bytes = Uint8List.fromList(
      List.unmodifiable(
        List.generate(
          4,
          (index) {
            List<int> byte = bin.sublist(index * 8, (index + 1) * 8);
            int sum = 0, pos = 0;
            for (var bit in byte) {
              sum += bit * pow(2, pos).toInt();
              pos++;
            }
            return sum;
          },
        ),
      ),
    );
    return bytes;
  }

  int _bytesToInt(Uint8List bytes) {
    List<int> bin = [];
    for (int b in bytes) {
      int rb = 8;
      while (b != 0) {
        bin.add(b % 2);
        b = b ~/ 2;
        rb--;
      }
      bin.addAll(List.filled(rb, 0));
    }
    int sum = 0, pos = 0;
    for (var bit in bin) {
      sum += bit * pow(2, pos).toInt();
      pos++;
    }
    return sum;
  }

  Uint8List _genID() {
    int id = 0;
    while (id < 16777216) {
      id = Random().nextInt(4294967295);
    }

    return _intToBytes(id);
  }

  Future<T?> send(T msg) async {
    while (_socket == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    List<int> msgBuffer = [];
    Uint8List id = _genID();
    msgBuffer.addAll(id);
    msgBuffer.add(0);
    msgBuffer.addAll(decode(msg));
    msgBuffer.addAll([0, 0, 0]);
    _socket!.add(msgBuffer);
    _Message reply = await _replyMessages
        .where((event) => event.id == _bytesToInt(id))
        .first;
    if (reply.data.isNotEmpty) {
      return encode(reply.data);
    }
  }

  void _sendReply(T? msg, int id) async {
    List<int> msgBuffer = [];
    msgBuffer.addAll(_intToBytes(id));
    msgBuffer.add(1);
    if (msg != null) {
      msgBuffer.addAll(decode(msg));
    }
    msgBuffer.addAll([0, 0, 0]);
    _socket!.add(msgBuffer);
  }
}

class BytesChannel extends Channel<Uint8List> {
  BytesChannel({required super.name});

  @override
  Uint8List decode(Uint8List data) {
    return data;
  }

  @override
  Uint8List encode(Uint8List data) {
    return data;
  }
}
