# python_channel

With this plugin developers can use python in there flutter applications on windows.

## requirements

+ python +3.7
+ flutter_channel python package, install it from [PyPi](https://pypi.org/project/flutter-channel/).

## how does it work?

This plugin depends on unix sockets (TCP) protocol.

## how to use?

### 1. bind the hosts

First thing you  have to  bind the hosts by calling `PythonChannelPlugin.bindHost()` this method take 4 parameters `name`,`debugPyPath`,`debugExePath`,`releasePath`, You can bind multi hosts.

`name` is unique name for the host

`debugPyPath` it is the absolute path of the main python file. The plugin will use it to start the host in debug mode if `debugExePath` is not set.

`debugExePath` it is the absolute path of the main executable file. You need to use is to debug the compiled file from python.

`releasePath` it is the relative path of the main executable file. in release mode you have to put the executable compiled file side by side with the application files *see the example on [github](https://github.com/Ghali01/python_channel)*

#### host example

```dart
PythonChannelPlugin.bindHost(
      name: 'host',
      debugExePath:
          'E:\\projects\\python_channel\\flutter_channel\\dist\\example.exe',
      debugPyPath: 'E:\\projects\\python_channel\\flutter_channel\\example.py',
      releasePath: 'main.exe');
```

##### where put the executable file in release mode?

```tree
  release-app/
    data/
    app.exe # the executable file for the flutter app
    main.exe # the executable file that compiled from python
    ...
```

### 2. create channels and bind it to host

There is number of built in channel types to use like:  `BytesChannel`,`JsonChannel`, `StringChannel` and `MethodChannel`, after you create the channel you have to bind it to host using `PythonChannelPlugin.bindChannel()` this method take two parameters first one is `name` is the name of the host and second one is `channel`.

#### channels examples

```dart

  BytesChannel bytesChannel = BytesChannel(name: 'channel1');
  StringChannel stringChannel = StringChannel(name: 'channel2');
  JsonChannel jsonChannel = JsonChannel(name: 'channel3');
  MethodChannel methodChannel = MethodChannel(name: 'channel4');
  // bind channels
  PythonChannelPlugin.bindChannel('host', bytesChannel);
  PythonChannelPlugin.bindChannel('host', stringChannel);
  PythonChannelPlugin.bindChannel('host', jsonChannel);
  PythonChannelPlugin.bindChannel('host', methodChannel);

```

### 3. set channel handler

The handler of the channel is a function that receive the messages that is sent to the channel, Each handler should take tow parameters `message` and `reply`.

`message`  is the first parameter and it is the massage that was received and it's type depends on the channel type see the following table.

| Channel Type | Channel Output |
|:---:|:---:|
| `BytesChannel` | `Uint8List` |
| `StringChannel` | `String` |
| `JsonChannel` | `Object` |
| `MethodChannel` | depends on reply that comes from python can be any primitive type like `int` ,`String`,`bool` or `List`   |
| custom channel | depends on the implement of the `encodeOutput` and `decodeOutput` methods |

`reply` is the second parameter, it is instance of `Reply` you should use this object to send reply on the received message, You can reply with another message or reply with `null`.
Your reply will not be sent to the channel handler in the python side. It will be send to the reply call back that used with `send` method in python side.

#### handler example

```dart
stringChannel.setHandler(
    (message, reply) {
        print(message);
        reply.reply('hi python');
    },
);
```

### 4. send message

You can send message using `send` method from the channel object. It take one parameter `msg` and the parameter type depends on the channel type see the following table.

| Channel Type | Channel Input |
|:---:|:---:|
| `BytesChannel` | `Uint8List` |
| `StringChannel` | `String` |
| `JsonChannel` | `Object` |
| `MethodChannel` | `MethodCall` |
| custom channel | depends on the implement of the `encodeInput` and `decodeInput` methods |

this method is `Future` that will keep wait until reply comes back.

#### send example

```dart
stringChannel.send('hello world').then((reply) => print(reply));

methodChannel.invokeMethod('sayHello', {"name": 'ghale'})   
        .then((reply) => print(reply));
```

### 5. get channel

You can access bound channel from anywhere using `PythonChannelPlugin.getChannel()`, This method take two parameters the `hostName` and `channelName`

#### get channel example

```dart
MethodChannel helloChannel = PythonChannelPlugin.getChannel('sayHello', 'sayHi') as MethodChannel;
```

### 6. unbind host

You can unbind host by calling `PythonChannelPlugin.unbindHost()`, This method take one parameter, that parameter is the host name. When unbind host the host process will be killed with it's all channels.

#### unbind host example

```dart
 PythonChannelPlugin.unbindHost('sayHello');
```

## MethodChannel

There is some notes we have to mention to about MethodChannel usage.

### 1. catch exception

If channel handler in python side raise `PythonChannelMethodException` you can catch it in dart side

```dart
methodChannel.invokeMethod('sayHello', {"name": 'ghale'})
      .then((reply) => print(reply))
      .catchError((e){});
     //or
      try{
        await methodChannel.invokeMethod('sayHello', {"name": 'ghale'});
      }catch(e){

      }
```

#### 2. throw exception in the handler

You can throw `PythonChannelMethodException` in the handler this exception will be sent by the channel and will pass to the second parameter of the reply call back in python side.

## create your own channel type

You can create your own channel by write class that inherit `Channel` generic class.
You should implement 4 method `encodeInput`, `encodeOutput` ,`decodeInput` and `decodeOutput`
and set the input/output types using the generic class.

+ `encodeInput` convert the input of the channel from `Uint8List`
+ `encodeOutput` convert the output of the channel from `Uint8List`
+ `decodeInput` convert the input of the channel to `Uint8List`
+ `decodeOutput` convert the input of the channel to `Uint8List`
where the **input** is what the channel send and the **output** is what the channel receive

## release mode

in release mode you have to compile your main python file to an executable file, We recommend you to use [PyInstaller](https://pypi.org/project/pyinstaller/).
**Note: you have to build the executable file with console otherwise the package will not work**
