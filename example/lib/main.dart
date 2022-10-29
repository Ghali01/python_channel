import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:python_channel/python_channel.dart';
import 'package:python_channel_example/home.dart';

void main() {
  PythonChannelPlugin.startChannels(
      debugPath: 'E:\\projects\\python_channel\\flutter_channel\\main.py',
      releasePath: 'example.exe');
  BytesChannel channel = BytesChannel(name: 'ch1');
  channel.setHandeler(
    (data, reply) {
      print(utf8.decode(data));
      reply.reply(null);
    },
  );
  channel
      .send(Uint8List.fromList(utf8.encode('hello world from dart')))
      .then((value) {
    if (value != null) {
      print('rp ' + utf8.decode(value));
    } else {
      print('rp null');
    }
  });
  BytesChannel debugCh = BytesChannel(name: 'debug');
  debugCh.setHandeler(
    (data, reply) {
      print('debug ch ' + utf8.decode(data));
    },
  );
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
