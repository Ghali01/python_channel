import 'package:flutter/material.dart';
import 'package:python_channel/python_channel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PythonChannelPlugin.bindHost(
      name: 'calculator',
      debugExePath:
          'E:\\projects\\python_channel\\flutter_channel\\dist\\calculator.exe',
      debugPyPath:
          'E:\\projects\\python_channel\\flutter_channel\\calculator-example.py',
      releasePath: 'calculator.exe');
  PythonChannelPlugin.bindHost(
      name: 'sayHello',
      debugExePath:
          'E:\\projects\\python_channel\\flutter_channel\\dist\\sayHello.exe',
      debugPyPath:
          'E:\\projects\\python_channel\\flutter_channel\\sayHello-example.py',
      releasePath: 'sayHello.exe');

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
  late final MethodChannel calculatorChannel;
  late final MethodChannel helloChannel;
  String res = '';
  String hi = '';
  final TextEditingController controller1 = TextEditingController(),
      controller2 = TextEditingController(),
      controller3 = TextEditingController();
  @override
  void initState() {
    super.initState();
    calculatorChannel = MethodChannel(name: 'ch');
    PythonChannelPlugin.bindChannel('calculator', calculatorChannel);
    helloChannel = MethodChannel(name: 'sayHi');
    PythonChannelPlugin.bindChannel('sayHello', helloChannel);
  }

  void getResault(String op) async {
    double res = await calculatorChannel.invokeMethod(op, [
      double.parse(controller1.text),
      double.parse(controller2.text)
    ]) as double;
    setState(() {
      this.res = res.toString();
    });
  }

  void getHello() async {
    var msg =
        await helloChannel.invokeMethod('sayHello', {'name': controller3.text});
    setState(() {
      hi = msg.toString();
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
              ),
              TextField(
                controller: controller3,
                decoration: const InputDecoration(hintText: 'your name'),
              ),
              Text(
                hi,
                style: const TextStyle(fontSize: 27),
              ),
              TextButton(
                  onPressed: getHello,
                  child: const Text(
                    'say hi',
                    style: TextStyle(fontSize: 25),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
