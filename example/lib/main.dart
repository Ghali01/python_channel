import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:python_channel/python_channel.dart';
import 'package:python_channel_example/home.dart';

void main() {
  PythonChannelPlugin.startChannels(
      debugPath: 'E:\\projects\\python_channel\\flutter_channel\\main.py',
      releasePath: 'example.exe');
  JsonChannel channel = JsonChannel(name: 'ch');
  channel.setHandeler((data, reply) {
    print('0 $data');
    reply.reply(null);
  });

  channel.send({'str': 1}).then((v) => print('rp: $v'));
  StringChannel channel2 = StringChannel(name: 'ch2');
  channel2.setHandeler(
    (p0, p1) {
      print(p0);
      p1.reply(null);
    },
  );

  channel2.send('ll').then((v) {});
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
