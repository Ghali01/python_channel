part of pythonChannel;

class Reply<T> {
  int msgId;
  Channel<T, dynamic> channel;
  Reply({
    required this.msgId,
    required this.channel,
  });
  void reply(T? msg) {
    channel._sendReply(msg, msgId);
  }
}
