part of pythonChannel;

/// This class present chanell that send and recive bytes [Uint8List]
class BytesChannel extends Channel<Uint8List, Uint8List> {
  BytesChannel({required super.name});

  @override
  Uint8List decodeInput(Uint8List data) {
    return data;
  }

  @override
  Uint8List decodeOutput(Uint8List data) {
    return data;
  }

  @override
  Uint8List encodeInput(Uint8List data) {
    return data;
  }

  @override
  Uint8List encodeOutput(Uint8List data) {
    return data;
  }
}
