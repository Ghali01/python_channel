part of pythonChannel;

class HostNotFoundException implements Exception {
  String name;
  HostNotFoundException({
    required this.name,
  });
  @override
  String toString() {
    return '$name host not found';
  }
}

class ChannelNotFoundException implements Exception {
  String name;
  ChannelNotFoundException({
    required this.name,
  });
  @override
  String toString() {
    return '$name channel not found';
  }
}
