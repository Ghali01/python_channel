part of pythonChannel;

/// class represent message through channels
class _Message {
  int id;
  bool isReply;
  Uint8List data;
  _Message({
    required this.id,
    required this.isReply,
    required this.data,
  });
}
