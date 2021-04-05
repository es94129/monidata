import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'cpu_usage.dart';
import 'disk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monidata',
      theme: ThemeData(
        fontFamily: 'Nunito',
        primaryColor: Color(0xff4895EF),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.pink,
              fontWeight: FontWeight.w900,
          ),
          bodyText1: TextStyle(
            color: Color(0xff212121),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: Color(0xff616161),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        )
      ),
      home: MyHomePage(title: 'Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;

  final _controller = PageController(initialPage: 0);
  final _pages = [
    DashboardPage(),
    CpuUsagePage(),
    DiskPage(),
  ];

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x00ffffff),
        elevation: 0,
        title: Text(
          widget.title,
        ),
      ),
      body: PageView(
        controller: _controller,
        children: _pages,
      )
    );
  }
}
