library pythonChannel;

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

part 'host.dart';

part 'channels/channel.dart';
part 'channels/byte_channel.dart';
part 'channels/string_channel.dart';
part 'channels/json_channel.dart';
part 'channels/method_channel.dart';

part 'exceptions/run_exception.dart';
part 'exceptions/args_method_call_exception.dart';
part 'exceptions/method_channel.dart';
part 'message.dart';
part 'reply.dart';
part 'method_call.dart';

/// the main class in the package
class PythonChannelPlugin {
  /// the entry point for the package
  ///
  /// [debugPyPath] the path of the python file
  /// [debugExePath] the path of the exe file in debug mode
  /// [releasePath] the relative path of the exe file in release mode
  static void startChannels(
      {required String debugPyPath,
      required String releasePath,
      String? debugExePath}) async {
    if (!_Host.runing) {
      WidgetsFlutterBinding.ensureInitialized();
      _Host.testPyPath = debugPyPath;
      _Host.releasePath = releasePath;
      _Host.testExePath = debugExePath;
      _Host.run().then((value) => null);

      // set up debug channel
      StringChannel debugChannel = StringChannel(name: '|debug|');

      debugChannel.setHandler((log, reply) {
        if (kDebugMode && !(log.length == 1 && log.codeUnits.first == 10)) {
          print('python channel log: $log');
        }
        reply.reply(null);
      });

      FlutterWindowClose.setWindowShouldCloseHandler(() async {
        await debugChannel._socket?.close();
        if (_Host.onClose != null) {
          _Host.onClose!();
        }
        await Future.delayed(const Duration(seconds: 1));
        return true;
      });
    }
  }

  /// set close application event
  static setOnClose(void Function() onClose) => _Host.onClose = onClose;
}
