part of pythonChannel;

class _Host {
  static late String testPath;
  static late String releasePath;
  static late Process process;
  static bool runing = false;
  static int? port;
  static Future<void> run() async {
    runing = true;
    if (kDebugMode) {
      process = await Process.start('python', [testPath]);
    } else {
      process = await Process.start(getPath(), []);
    }

    process.stderr.transform(utf8.decoder).listen(print);
    List<int> pb = await process.stdout.first;
    String sp = utf8.decode(pb);
    try {
      // int p = 54111;
      int p = int.parse(sp);
      _Host.port = p;
    } catch (e) {
      throw PythonChannelRunError(output: sp);
    }
    await process.exitCode;
    print('stoped');

    await run();
  }

  static String getPath() {
    List l = Platform.resolvedExecutable.split('\\');
    l.removeLast();
    return '${l.join('\\')}\\$releasePath';
  }
}
