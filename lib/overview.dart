import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'node_detail.dart';
import 'netdata/info.dart';
import 'netdata/chart.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage({Key key}) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<OverviewPage> {
  Future<Info> futureInfo;
  String chartName = 'CPU';

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
        body: Column(children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Overview of   ',
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              DropdownButton(
                value: chartName,
                style: Theme.of(context).primaryTextTheme.bodyText1,
                icon: const Icon(Icons.arrow_drop_down_circle),
                onChanged: (String newValue) {
                  setState(() {
                    chartName = newValue;
                  });
                },
                items: <String>['CPU', 'Load', 'System RAM', 'Network traffic']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<Info>(
              future: futureInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
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
          ),
        ]));
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
  Future<Chart> futureChart;
  Timer timer;

  @override
  void initState() {
    super.initState();
    futureInfo = fetchInfo(widget.hostname);
    futureChart = fetchChart(widget.hostname, 1, 'system.cpu');
    timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              futureChart = fetchChart(widget.hostname, 1, 'system.cpu');
            }));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                    ? Text(
                        'Clear',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            FutureBuilder<Chart>(
                future: futureChart,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double cpuUsage = 0;
                    for (int i = 1;
                        i < snapshot.data.data[0].values.length;
                        i++) cpuUsage += snapshot.data.data[0].values[i];
                    return Column(
                      children: <Widget>[
                        Text(
                          'Total: ${cpuUsage.toStringAsFixed(2)}%',
                          style: Theme.of(context).primaryTextTheme.bodyText2,
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 12,
                            disabledActiveTrackColor:
                                Theme.of(context).primaryColor,
                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 0.0), // hide thumb
                          ),
                          child: Slider(
                            value: cpuUsage,
                            min: 0,
                            max: 100,
                            onChanged: null,
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container();
                }),
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

Future<Chart> fetchChart(String hostname, int time, String chartName) async {
  final response = await http.get(Uri.http(
      "166.111.69.76:19999", "/host/" + hostname + "/api/v1/data", {
    "chart": chartName,
    "after": "-" + time.toString(),
    "options": "nonzero"
  }));
  if (response.statusCode == 200) {
    return Chart().fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load info");
  }
}
