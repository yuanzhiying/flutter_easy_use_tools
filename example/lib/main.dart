import 'package:flutter/material.dart';
import 'package:flutter_easy_use_tools/flutter_easy_use_tools.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              color: Colors.green,
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(20),
              child: MaterialButton(
                onPressed: () {
                  print(NumUtil.formatNum(12.12345678, 2));
                },
                child: Text('测试NumUtil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
