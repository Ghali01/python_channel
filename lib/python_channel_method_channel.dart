import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'python_channel_platform_interface.dart';

/// An implementation of [PythonChannelPlatform] that uses method channels.
class MethodChannelPythonChannel extends PythonChannelPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('python_channel');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
