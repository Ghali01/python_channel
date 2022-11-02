import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:python_channel/python_channel.dart';
import 'package:python_channel_example/home.dart';

void main() {
  PythonChannelPlugin.startChannels(
      debugPath: 'E:\\projects\\python_channel\\flutter_channel\\main.py',
      releasePath: 'example.exe');
  MethodChannel channel = MethodChannel(name: 'ch');
  channel.setHandeler(((p0, p1) {
    throw PythonMethodException(
        code: 111, message: 'message', details: 'details');
  }));
  // channel
  //     .send(MethodCall(method: 'add', args: [11, 3]))
  //     .then((value) => print(value))
  //     .onError((error, stackTrace) => print(error));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
