part of pythonChannel;

/// The base class for the channels
///
/// Developers can extends this class to code channels
abstract class Channel<O, I> {
  String name;
  Socket? _socket;
  late Stream<_Message> _dataMessages;
  late Stream<_Message> _replyMessages;
  int? _port;
  StreamSubscription? _subscription;

  void Function(I, Reply<O>)? _handler;

  Channel({
    required this.name,
  }) {
    _connect().then((value) => null);

    _dataMessages = _listenToDataMessage().asBroadcastStream();

    _startListenOnMsgs();

    _replyMessages =
        _dataMessages.where((event) => event.isReply).asBroadcastStream();
  }

  /// set the handler used to handel the channel message
  void setHandler(void Function(I, Reply<O>) handler) => _handler = handler;

  void _startListenOnMsgs() {
    _dataMessages.where((event) => !event.isReply).listen((event) {
      if (_handler != null) {
        Reply<O> reply = Reply(msgId: event.id, channel: this);
        _handler!(encodeInput(event.data), reply);
      }
    });
  }

  /// conect to the tcp socket
  Future<void> _connect() async {
    while (_port == null) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    _socket = await Socket.connect('127.0.0.1', _port!);
    Uint8List nameMsg = Uint8List.fromList([...utf8.encode(name), 0, 0, 0]);
    try {
      _socket!.add(nameMsg);
    } catch (e) {}
  }

  /// check if there is msessage in the [buffer] and return the index of the prefix.
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

  /// encode the output of the channel from bytes
  O encodeOutput(Uint8List data);

  /// decode the output of the channel to bytes
  Uint8List decodeOutput(O data);

  /// encode the input of the channel from bytes
  I encodeInput(Uint8List data);

  /// decode the input of the channel to bytes
  Uint8List decodeInput(I data);

  ///  listen to messages that come from the socket
  Stream<_Message> _listenToDataMessage() async* {
    while (_socket == null) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    bool connected = true;
    List<int> buffer = [];

    // add to the buffer
    _subscription = _socket!.listen((data) {
      buffer.addAll(data);
    }, onDone: () => connected = false, cancelOnError: true);

    // if there is message in the buffer yield it
    while (connected) {
      int? index = _checkOnPerfex(buffer);
      if (index != null) {
        // get msg id
        int msgId = _bytesToInt(Uint8List.fromList(buffer.sublist(0, 4)));

        // get the message
        Uint8List msg = Uint8List.fromList(buffer.sublist(5, index));
        yield _Message(id: msgId, data: msg, isReply: buffer[4] == 1);
        // remove the message
        buffer = buffer.sublist(index + 3);
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    print('disconnected $name');
  }

  /// convert int to 4 bytes Uint8List
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

  /// convert 4 bytes Uint8List to int
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

  /// generate id to message
  Uint8List _genID() {
    int id = 0;
    while (id < 16777216) {
      id = Random().nextInt(4294967295);
    }

    return _intToBytes(id);
  }

  /// send message through the channel
  Future<O?> send(I msg) async {
    while (_socket == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    List<int> msgBuffer = [];
    // generate and add the id
    Uint8List id = _genID();
    msgBuffer.addAll(id);
    // add (is reply) byte
    msgBuffer.add(0);
    msgBuffer.addAll(decodeInput(msg));
    msgBuffer.addAll([0, 0, 0]);

    try {
      _socket!.add(msgBuffer);
    } catch (e) {}
    // wait the reply
    _Message reply = await _replyMessages
        .where((event) => event.id == _bytesToInt(id))
        .first;
    if (reply.data.isNotEmpty) {
      return encodeOutput(reply.data);
    }
  }

  /// send reply on message
  void _sendReply(O? msg, int id) async {
    List<int> msgBuffer = [];
    msgBuffer.addAll(_intToBytes(id));
    msgBuffer.add(1);
    if (msg != null) {
      msgBuffer.addAll(decodeOutput(msg));
    }
    msgBuffer.addAll([0, 0, 0]);
    try {
      _socket!.add(msgBuffer);
    } catch (e) {}
  }

  void _disconnect() async {
    await _subscription?.cancel();
    await _socket?.close();
    _socket = null;
  }
}
