import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'python_channel_method_channel.dart';

abstract class PythonChannelPlatform extends PlatformInterface {
  /// Constructs a PythonChannelPlatform.
  PythonChannelPlatform() : super(token: _token);

  static final Object _token = Object();

  static PythonChannelPlatform _instance = MethodChannelPythonChannel();

  /// The default instance of [PythonChannelPlatform] to use.
  ///
  /// Defaults to [MethodChannelPythonChannel].
  static PythonChannelPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PythonChannelPlatform] when
  /// they register themselves.
  static set instance(PythonChannelPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
