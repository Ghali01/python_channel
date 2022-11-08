library pythonChannel;

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

part 'host.dart';

part 'channels/channel.dart';
part 'channels/byte_channel.dart';
part 'channels/string_channel.dart';
part 'channels/json_channel.dart';
part 'channels/method_channel.dart';

part 'exceptions/run_exception.dart';
part 'exceptions/args_method_call_exception.dart';
part 'exceptions/method_channel.dart';
part 'exceptions/host_exception.dart';
part 'message.dart';
part 'reply.dart';
part 'method_call.dart';

/// the main class in the package
class PythonChannelPlugin {
  static Map<String, _Host> _hosts = {};

  /// the entry point for the package
  ///
  /// [debugPyPath] the path of the python file
  /// [debugExePath] the path of the exe file in debug mode
  /// [releasePath] the relative path of the exe file in release mode
  static void bindHost(
      {required String name,
      required String debugPyPath,
      required String releasePath,
      String? debugExePath}) {
    _Host host = _Host(
        debugPyPath: debugPyPath,
        releasePath: releasePath,
        debugExePath: debugExePath);
    _hosts[name] = host;
  }

  static void bindChannel(String hostName, Channel channel) {
    if (_hosts.containsKey(hostName)) {
      _hosts[hostName]!.bindChannel(channel);
    } else {
      throw HostNotFoundException(name: hostName);
    }
  }
}
