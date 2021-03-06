import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PingPage extends StatefulWidget {
  PingPage();

  @override
  State<StatefulWidget> createState() {
    return PingPageState();
  }
}

class PingPageState extends State {
  PingPageState();
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  final TextEditingController _controller3 = new TextEditingController();
  final TextEditingController _controller4 = new TextEditingController();
  final TextEditingController _controller5 = new TextEditingController();
  final TextEditingController _controller6 = new TextEditingController();
  final TextEditingController _controller7 = new TextEditingController();
  final TextEditingController _controller8 = new TextEditingController();
  List<TextEditingController> _remarkControllers = [];

  String currentIP = '0.0.0.0';
  String scanIP = '0.0.0.0';

  List<List<dynamic>> scanResult = [];
  Map<String, num> history = new Map<String, num>();
  Map<String, num> indexMap = new Map<String, num>();
  @override
  void initState() {
    _controller1.text = "102";
    _controller2.text = "244";
    _controller3.text = "1";
    _controller4.text = "1";
    _controller5.text = "102";
    _controller6.text = "244";
    _controller7.text = "1";
    _controller8.text = "20";

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _renderIPInput(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        color: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.0,
              child: TextField(
                controller: _controller1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '102',
                ),
              ),
            ),
            Container(
              width: 100.0,
              child: TextField(
                controller: _controller2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '102',
                ),
              ),
            ),
            Container(
              width: 100.0,
              child: TextField(
                controller: _controller3,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '102',
                ),
              ),
            ),
            Container(
              width: 100.0,
              child: TextField(
                controller: _controller4,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '102',
                ),
              ),
            ),
            Container(
              child: Text("   ==>   "),
            ),
            Container(
              width: 100.0,
              child: TextField(
                controller: _controller5,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '102',
                ),
              ),
            ),
            Container(
              width: 100.0,
              child: TextField(
                controller: _controller6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '102',
                ),
              ),
            ),
            Container(
              width: 100.0,
              child: TextField(
                controller: _controller7,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '102',
                ),
              ),
            ),
            Container(
              width: 100.0,
              child: TextField(
                controller: _controller8,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '102',
                ),
              ),
            ),
          ],
        ));
  }

  // ???IP???????????????
  num ip2decimalism(
      String field1, String field2, String field3, String field4) {
    num ipnum1 = pow(2, 24) * int.parse(field1);
    num ipnum2 = pow(2, 16) * int.parse(field2);
    num ipnum3 = pow(2, 8) * int.parse(field3);
    num ipnum4 = pow(2, 0) * int.parse(field4);

    return ipnum1 + ipnum2 + ipnum3 + ipnum4;
  }

  // ??????????????????IP
  String decimalism2ip(int ipnum) {
    String field1 = (ipnum >> 24).toString();
    ipnum = ipnum - (pow(2, 24) * int.parse(field1)).toInt();
    String field2 = (ipnum >> 16).toString();
    ipnum = ipnum - (pow(2, 16) * int.parse(field2)).toInt();
    String field3 = (ipnum >> 8).toString();
    ipnum = ipnum - (pow(2, 8) * int.parse(field3)).toInt();
    String field4 = ipnum.toString();

    return field1 + "." + field2 + "." + field3 + "." + field4;
  }

  getList() async {
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "\\ipscan.csv";
    File file = new File(pathOfTheFileToWrite);
    try {
      String content = await file.readAsString();
      List<List<dynamic>> list = CsvToListConverter().convert(content);

      for (var i = 0; i < list.length; i++) {
        history[list[i][0]] = list[i][1];

        indexMap[list[i][0]] = i;

        _remarkControllers.add(new TextEditingController(text: list[i][3]));
      }
      scanResult = list;
    } catch (e) {
      print(e);
    }
  }

  save() async {
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "\\ipscan.csv";

    for ( var i = 0 ; i < scanResult.length; i++) {
      scanResult[i][3] = _remarkControllers[i].text;
    }

    String csv = const ListToCsvConverter().convert(scanResult);
  
    File file = File(pathOfTheFileToWrite);
    file.writeAsString(csv);
  }

  // ?????????????????????????????????????????????????????????????????????IP?????????
  startScan() {
    // ?????????
    num startIP = ip2decimalism(_controller1.text, _controller2.text,
        _controller3.text, _controller4.text);
    num endIP = ip2decimalism(_controller5.text, _controller6.text,
        _controller7.text, _controller8.text);

    int index = 0;
    while (startIP <= endIP) {
      String ip = decimalism2ip(startIP.toInt());
      final ping = Ping(ip, count: 5);

      List<dynamic> line = [];
      // Begin ping process and listen for output
      ping.stream.listen((event) {
        if (event.response != null) {
          return; // ??????
        }

        if (event.summary!.received > 0) {
          num? count = this.history[ip];
          if (count == null) count = 0;
          line = [
            ip,
            count + 1,
            DateTime.now().year.toString() +
                "-" +
                DateTime.now().month.toString() +
                "-" +
                DateTime.now().day.toString()
          ];
        } else {
          line = [ip, 0, ""];
        }

        if (this.indexMap.containsKey(ip)) {
          // ??????????????????
          num? index = this.indexMap[ip];
          this.scanResult[index!.toInt()] = line;
        } else {
          this.scanResult.add(line);
        }
      }, onDone: () {
        setState(() {
          scanIP = ip;
        });
        if (startIP > endIP) {
          save();
        }
      });
      setState(() {
        scanIP = scanIP + "...";
      });
      // sleep(Duration(seconds: 5));

      index++;
      startIP++;
    }
  }

  startScan2() async {
    ProcessResult result;

    if (Platform.isWindows) {
      // ?????????
      num startIP = ip2decimalism(_controller1.text, _controller2.text,
          _controller3.text, _controller4.text);
      num endIP = ip2decimalism(_controller5.text, _controller6.text,
          _controller7.text, _controller8.text);

      int index = 0;

      while (startIP <= endIP) {
        String ip = decimalism2ip(startIP.toInt());
        setState(() {
          scanIP = "????????????" + ip + "...";
        });

        result = await Process.run("ping", [ip]);
        var data = result.stdout.toString();
        List<dynamic> line = [];
        if (data.contains("TTL=")) {
          // ????????????
          num? count = history[ip];
          if (count == null) count = 0;
          line = [
            ip,
            count + 1,
            DateTime.now().year.toString() +
                "-" +
                DateTime.now().month.toString() +
                "-" +
                DateTime.now().day.toString(),
            "???"
          ];
        } else {
          if (history.containsKey(ip)) {
            num? count = history[ip];
            if (count == null) count = 0;
            line = [ip, count, "", "???"];
          } else {
            line = [ip, 0, "", "???"];
          }
        }

        setState(() {
          scanIP = "???????????? :" + ip + "\n" + line.toString();
        });
        if (indexMap.containsKey(ip)) {
          // ??????????????????
          num? index = indexMap[ip];
          scanResult[index!.toInt()] = line;
        } else {
          scanResult.add(line);
          indexMap[ip] = scanResult.length - 1 ;
           _remarkControllers.add(new TextEditingController(text: "???"));
        }

        index++;
        startIP++;
      }
      save();
    }
  }

  _renderTable() {
    final rows = <TableRow>[];
    for (var i = 0; i < scanResult.length; i++) {
      if (scanResult[i].length != 4) continue;
      var item = TableRow(
          //??????????????? ???????????????
          decoration: BoxDecoration(
            color: Colors.tealAccent,
          ),
          children: [
            SizedBox(
              height: 30.0,
              child: Center(
                child: Text(
                  scanResult[i][0].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Text(
                scanResult[i][1].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                scanResult[i][2].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Center(
            //   child: Container(
            //     color: Colors.amberAccent,
            //     child: TextField(
            //       controller: _remarkControllers[i],
            //       keyboardType: TextInputType.text,
            //       decoration: InputDecoration(
            //         hintText: '??????',
            //       ),
            //     ),
            //   ),
            // ),
            Center(
              child: Container(
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (event) {
                    save();
                  },
                  child: TextFormField(
                    controller: _remarkControllers[i],
                    onFieldSubmitted: (_textController) {
                      save();
                    },
                  ),
                ),
              ),
            )
          ]);
      rows.add(item);
    }

    print("rows length ${rows.length}");
    return Container(
        //??????
        width: MediaQuery.of(context).size.width - 20,
        child: Table(
            //????????????
            columnWidths: const {
              //??????
              0: FixedColumnWidth(100.0),
              1: FixedColumnWidth(100.0),
              2: FixedColumnWidth(50.0),
              3: FixedColumnWidth(200.0),
            },
            //??????????????????
            border: TableBorder.all(
              color: Colors.black,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                  //??????????????? ???????????????
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                  children: [
                    //????????????
                    SizedBox(
                      height: 30.0,
                      child: Center(
                        child: Text(
                          'IP',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '????????????',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        '????????????',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        '??????',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
              ...rows,
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("??????IP?????? Power by JJ long"),
        ),
         floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save ,color: Colors.black,size: 40,),
          onPressed: (){
            save();
          },
          backgroundColor: Colors.yellow
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderIPInput(context),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.all(10)),
                  onPressed: () async {
                    await getList();
                    startScan2();
                    await getList();
                  },
                  child: Text("????????????")),
              Text(scanIP),
              _renderTable(),
              Container(
                child: Image.asset("images/logo.png", width: 200.0),
              ),
            ],
          ),
        ));
  }
}
