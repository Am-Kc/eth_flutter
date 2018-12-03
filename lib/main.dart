import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'p',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _value;
  bool _socketStatus = true;
  IOWebSocketChannel channel;

  @override
  void initState() {
    connectSocket();
    super.initState();
  }

  @override
  void dispose() {
    closeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData iconStatus;
    if (_socketStatus) {
      iconStatus = Icons.cloud;
    } else {
      iconStatus = Icons.cloud_off;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
          padding: const EdgeInsets.all(32.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new InkWell(
                  onTap: () {
                    switchTab();
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(iconStatus, size: 20.0, color: Colors.blue),
                      new Text("eth/usdt",
                          style: TextStyle(color: Colors.blue, fontSize: 24.0))
                    ],
                  )),
              new Text(
                _value,
                style: TextStyle(color: Colors.black, fontSize: 22.0),
              )
            ],
          )),
    );
  }

  connectSocket() async {
    channel = new IOWebSocketChannel.connect("wss://api.huobi.br.com/ws");
    channel.sink.add("""{"sub": "market.ethusdt.kline.1min","id": "id10"}""");
    channel.stream.listen((data) {
      var bytes = new GZipDecoder().decodeBytes(data);
      var msg = utf8.decode(bytes);
      if (msg.startsWith('{"ping"')) {
        var ts = msg.substring(8, 21);
        var pong = '{"pong":$ts}';
        channel.sink.add(pong);
      } else {
        var json = jsonDecode(msg);
        var tick = json['tick'].toString();
        var result = tick.substring(1, tick.length - 1).replaceAll(', ', '\n');
        setState(() {
          _value = result;
        });
      }
    });
  }

  void closeSocket() async {
    if (channel == null) return;
    await channel.sink.close(status.goingAway, '');
    channel = null;
  }

  void switchTab() {
    if (_socketStatus) {
      closeSocket();
    } else {
      connectSocket();
    }
    setState(() {
      _socketStatus = !_socketStatus;
    });
  }
}
