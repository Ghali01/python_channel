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

class PythonChannelPlugin {
  static void startChannels(
      {required String debugPath, required String releasePath}) async {
    if (!_Host.runing) {
      WidgetsFlutterBinding.ensureInitialized();
      _Host.testPath = debugPath;
      _Host.releasePath = releasePath;
      _Host.run().then((value) => print('done'));
      StringChannel debugChannel = StringChannel(name: '|debug|');
      FlutterWindowClose.setWindowShouldCloseHandler(() async {
        await debugChannel._socket?.close();

        return true;
      });
      debugChannel.setHandeler((log, reply) {
        if (kDebugMode && !(log.length == 1 && log.codeUnits.first == 10)) {
          print('python channel log: $log');
        }
        reply.reply(null);
      });
    }
  }
}
