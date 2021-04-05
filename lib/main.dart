import 'package:flutter/material.dart';

import 'node_list.dart';

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
          backgroundColor: Color(0xfff9f7fa),
          primaryTextTheme: TextTheme(
            headline5: TextStyle(
                color: Color(0xff212121), fontWeight: FontWeight.bold),
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
          ),
          iconTheme: IconThemeData(color: Color(0xff212121))),
      home: MyHomePage(
        title: 'Realtime systems monitoring',
      ),
      routes: {
        '/node_list': (context) => NodeListPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x00ffffff),
          elevation: 0,
          title: Text(
            this.title,
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Card(
                color: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      // TODO: navigate
                    },
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 300,
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Nodes Overview',
                            style: Theme.of(context).primaryTextTheme.headline5,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          image:
                              AssetImage('assets/images/homepage-cluster.png'),
                          height: 150,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      Navigator.pushNamed(context, "/node_list");
                    },
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 300,
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Node Details',
                            style: Theme.of(context).primaryTextTheme.headline5,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image(
                          image:
                              AssetImage('assets/images/homepage-server.png'),
                          height: 150,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
