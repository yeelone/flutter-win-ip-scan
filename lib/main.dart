
import 'package:flutter/material.dart';
import 'package:ipscan/ping/ping.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jiangyilong Toolset',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Jiangyilong Toolset'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.asset("images/logo.png", width: 200.0),
            ),
           TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.all(10)
              ),
          onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PingPage()))
           },
           child: Text("内网IP扫描"))
          ],
        ),
      ),
    );
  }
}
