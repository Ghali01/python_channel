part of pythonChannel;

/// Class repersent the Host of the python code
class _Host {
  String debugPyPath;
  String? debugExePath;
  String releasePath;
  late Process _process;
  bool runing = false;
  static int? _port;
  List<Channel> _channels = [];

  /// [debugPyPath] the path of the python file
  /// [debugExePath] the path of the exe file in debug mode
  /// [releasePath] the relative path of the exe file in release mode
  _Host({
    required this.debugPyPath,
    required this.releasePath,
    this.debugExePath,
  }) {
    run().then((value) => null);
    // set up debug channel
    StringChannel debugChannel = StringChannel(name: '|debug|');

    debugChannel.setHandler((log, reply) {
      if (kDebugMode && !(log.length == 1 && log.codeUnits.first == 10)) {
        print('python channel log: $log');
      }
      reply.reply(null);
    });
    Stream.periodic(const Duration(seconds: 8), (_) => null)
        .listen((event) async => await debugChannel.send(' '));
    bindChannel(debugChannel);
  }

  /// run the python host
  Future<void> run() async {
    runing = true;
    if (kDebugMode) {
      if (debugExePath != null) {
        _process = await Process.start(debugExePath!, ['dart']);
      } else {
        _process = await Process.start('python', [debugPyPath, 'dart']);
      }
    } else {
      _process = await Process.start(_getPath(), ['dart']);
    }

    _process.stderr.transform(utf8.decoder).listen(print);
    List<int> pb = await _process.stdout.first;
    String sp = utf8.decode(pb);
    try {
      // int p = 54111;
      int p = int.parse(sp);

      _port = p;
      _channels.forEach((element) => element._port = p);
    } catch (e) {
      throw PythonChannelRunError(output: sp);
    }
    await _process.exitCode;
    // print('stoped');

    await run();
  }

  void bindChannel(Channel channel) {
    channel._port = _port;
    _channels.add(channel);
  }

  /// get the path of the exe file relative to the program
  String _getPath() {
    List l = Platform.resolvedExecutable.split('\\');
    l.removeLast();
    return '${l.join('\\')}\\$releasePath';
  }
}
