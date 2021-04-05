import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'netdata/chart.dart';

class NodeDetailPage extends StatefulWidget {
  final String hostname;

  NodeDetailPage({Key key, this.hostname}) : super(key: key);

  @override
  _NodeDetailState createState() => _NodeDetailState();
}

class _NodeDetailState extends State<NodeDetailPage> {
  Future<Chart> futureChart;

  @override
  void initState() {
    super.initState();
    futureChart = fetchChart(widget.hostname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x00ffffff),
          elevation: 0,
          title: Text(widget.hostname),
          iconTheme: Theme
              .of(context)
              .iconTheme,
        ),
        body: Center(
            child: FutureBuilder<Chart>(
              future: futureChart,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.labels[0]);
                }
                else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            )
        )
    );
  }
}

Future<Chart> fetchChart(String hostname) async {
  final response = await http.get(Uri.http("166.111.69.76:19999",
      "/host/" + hostname + "/api/v1/data",
      {"chart": "system.cpu"}));
  if (response.statusCode == 200) {
    return Chart().fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load info");
  }
}