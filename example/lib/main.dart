import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:python_channel/python_channel.dart';

void main() {
  PythonChannelPlugin.startChannels(
      // debugExePath:
      //     'E:\\projects\\python_channel\\flutter_channel\\dist\\example.exe',
      debugPyPath: 'E:\\projects\\python_channel\\flutter_channel\\example.py',
      releasePath: 'main.exe');

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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final MethodChannel channel;
  String res = '';
  final TextEditingController controller1 = TextEditingController(),
      controller2 = TextEditingController();
  @override
  void initState() {
    super.initState();
    channel = MethodChannel(name: 'ch');
  }

  void getResault(String op) async {
    DateTime d1 = DateTime.now();
    double res = await channel.invokeMethod(op, [
      double.parse(controller1.text),
      double.parse(controller2.text)
    ]) as double;
    DateTime d2 = DateTime.now();
    print('${d2.difference(d1).inMilliseconds} ms');
    setState(() {
      this.res = res.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: controller1,
                decoration: const InputDecoration(hintText: 'number 1'),
              ),
              TextField(
                controller: controller2,
                decoration: const InputDecoration(hintText: 'number 1'),
              ),
              Text(
                res,
                style: const TextStyle(fontSize: 27),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => getResault('add'),
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 25),
                      )),
                  TextButton(
                      onPressed: () => getResault('sub'),
                      child: const Text(
                        '-',
                        style: TextStyle(fontSize: 25),
                      )),
                  TextButton(
                      onPressed: () => getResault('mul'),
                      child: const Text(
                        '×',
                        style: TextStyle(fontSize: 25),
                      )),
                  TextButton(
                      onPressed: () => getResault('div'),
                      child: const Text(
                        '÷',
                        style: TextStyle(fontSize: 25),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
