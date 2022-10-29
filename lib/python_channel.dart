library pythonChannel;

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';

part 'host.dart';
part 'exceptions/run_exception.dart';
part 'channels/channel.dart';
part 'message.dart';
part 'reply.dart';

class PythonChannelPlugin {
  static void startChannels(
      {required String debugPath, required String releasePath}) async {
    if (!_Host.runing) {
      _Host.testPath = debugPath;
      _Host.releasePath = releasePath;
      _Host.run().then((value) => print('done'));
    }
  }
}
