part of pythonChannel;

/// Class repersent the Host of the python code
class _Host {
  static late String testPyPath;
  static String? testExePath;
  static late String releasePath;
  static late Process process;
  static bool runing = false;
  static int? port;
  static void Function()? onClose;

  /// run the python host
  static Future<void> run() async {
    runing = true;
    if (kDebugMode) {
      if (testExePath != null) {
        process = await Process.start(testExePath!, ['dart']);
      } else {
        process = await Process.start('python', [testPyPath, 'dart']);
      }
    } else {
      process = await Process.start(getPath(), ['dart']);
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

  /// get the path of the exe file relative to the program
  static String getPath() {
    List l = Platform.resolvedExecutable.split('\\');
    l.removeLast();
    return '${l.join('\\')}\\$releasePath';
  }
}
