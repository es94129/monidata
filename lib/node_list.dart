import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monidata/node_detail.dart';

import 'netdata/info.dart';

class NodeListPage extends StatefulWidget {
  NodeListPage({Key key}) : super(key: key);

  @override
  _NodeListState createState() => _NodeListState();
}

class _NodeListState extends State<NodeListPage> {
  Future<Info> futureInfo;

  @override
  void initState() {
    super.initState();
    futureInfo = fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x00ffffff),
        elevation: 0,
        title: Text('Monitoring nodes'),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: FutureBuilder<Info>(
          future: futureInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
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
                                  hostname: snapshot.data.mirroredHosts[index]),
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
                                width: 300,
                                height: 40,
                                child: Text(
                                  snapshot.data.mirroredHosts[index],
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1,
                                ),
                              )
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
      ),
    );
  }
}

Future<Info> fetchInfo() async {
  final response =
      await http.get(Uri.http("166.111.69.76:19999", "/api/v1/info"));
  if (response.statusCode == 200) {
    return Info().fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load info");
  }
}
