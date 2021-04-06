import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'node_detail.dart';
import 'netdata/info.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage({Key key}) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<OverviewPage> {
  Future<Info> futureInfo;

  @override
  void initState() {
    super.initState();
    futureInfo = fetchInfo('master');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x00ffffff),
          elevation: 0,
          title: Text('Nodes overview'),
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Center(
          child: FutureBuilder<Info>(
            future: futureInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  padding: const EdgeInsets.all(20),
                  itemCount: snapshot.data.mirroredHosts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: Theme.of(context).backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NodeDetailPage(
                                    hostname:
                                        snapshot.data.mirroredHosts[index]),
                              ),
                            );
                          },
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  child: Text(
                                    snapshot.data.mirroredHosts[index],
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1,
                                  ),
                                ),
                                NodeOverview(
                                    hostname:
                                        snapshot.data.mirroredHosts[index]),
                              ],
                            ),
                          ),
                        ));
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ));
  }
}

class NodeOverview extends StatefulWidget {
  final String hostname;

  NodeOverview({Key key, this.hostname}) : super(key: key);

  @override
  _NodeOverviewState createState() => _NodeOverviewState();
}

class _NodeOverviewState extends State<NodeOverview> {
  Future<Info> futureInfo;

  @override
  void initState() {
    super.initState();
    futureInfo = fetchInfo(widget.hostname);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Info>(
      future: futureInfo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                snapshot.data.warnings > 0
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        width: 30,
                        child: Center(
                          child: Text(
                            snapshot.data.warnings.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                    : Container(),
                snapshot.data.criticals > 0
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        width: 30,
                        child: Center(
                          child: Text(
                            snapshot.data.criticals.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                    : Container(),
                snapshot.data.warnings == 0 && snapshot.data.criticals == 0
                    ? Text('Clear', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)
                    : Container(),
              ],
            ),
          ]);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}

Future<Info> fetchInfo(String hostname) async {
  final response = await http.get(
      Uri.http("166.111.69.76:19999", "/host/" + hostname + "/api/v1/info"));
  if (response.statusCode == 200) {
    return Info().fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load info");
  }
}