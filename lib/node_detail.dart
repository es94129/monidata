import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

import 'indicator.dart';
import 'netdata/chart.dart';

class NodeDetailPage extends StatefulWidget {
  final String hostname;

  NodeDetailPage({Key key, this.hostname}) : super(key: key);

  @override
  _NodeDetailState createState() => _NodeDetailState();
}

class _NodeDetailState extends State<NodeDetailPage> {
  Future<Chart> futureChart;
  String chartName = "CPU";
  String chartUnit = "%";

  final nameToChart = {
    'CPU': {'name': 'system.cpu', 'unit': '%'},
    'Load': {'name': 'system.load', 'unit': 'processes'},
    'Disk I/O': {'name': 'system.io', 'unit': 'KB/s'},
    'System RAM': {'name': 'system.ram', 'unit': 'GB'},
    'Network traffic': {'name': 'system.ip', 'unit': 'megabits/s'},
  };

  @override
  void initState() {
    super.initState();
    futureChart = fetchChart(widget.hostname, 180, 'system.cpu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x00ffffff),
          elevation: 0,
          title: Text(widget.hostname),
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Dashboard of   ',
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                    DropdownButton(
                      value: chartName,
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      onChanged: (String newValue) {
                        setState(() {
                          chartName = newValue;
                          chartUnit = nameToChart[chartName]['unit'];
                          futureChart = fetchChart(widget.hostname, 180,
                              nameToChart[chartName]['name']);
                        });
                      },
                      items: <String>[
                        'CPU',
                        'Load',
                        'Disk I/O',
                        'System RAM',
                        'Network traffic'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                AspectRatio(
                    aspectRatio: 1.0,
                    child: FutureBuilder<Chart>(
                      future: futureChart,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return LineChart(LineChartData(
                            lineBarsData: barDataLines(snapshot.data.data),
                            minY: chartName == 'CPU'? 0: null,
                            maxY: chartName == 'CPU'? 100: null,
                            backgroundColor: Theme.of(context).backgroundColor,
                            gridData: FlGridData(
                              show: false,
                            ),
                            borderData: FlBorderData(
                              border: const Border(
                                bottom: BorderSide(
                                  color: Colors.black54,
                                  width: 4,
                                ),
                                left: BorderSide(
                                  color: Colors.transparent,
                                ),
                                right: BorderSide(
                                  color: Colors.transparent,
                                ),
                                top: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText2,
                                    getTitles: (timestamp) {
                                      if ((timestamp / 5).floor() * 5 % 60 ==
                                          0) {
                                        var datetime =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                timestamp.toInt() * 1000);
                                        return TimeOfDay.fromDateTime(datetime)
                                            .format(context);
                                      }

                                      return '';
                                    }),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTextStyles: (value) => Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText2,
                                )),
                          ));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                    )),
                Text(
                  '(' + chartUnit + ')',
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
                SizedBox(
                  height: 16,
                ),
                FutureBuilder<Chart>(
                  future: futureChart,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: indicators(snapshot.data.labels),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return SizedBox(
                      height: 1,
                    );
                  },
                ),
              ],
            )));
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

List<LineChartBarData> barDataLines(List<Data> data) {
  final colors = <Color>[
    Color(0xaaF72585),
    Color(0xaa3F37C9),
    Color(0xaa4895EF),
    Color(0xaa4CC9F0),
    Colors.lightGreen.withOpacity(0.7),
  ];

  var lines = <LineChartBarData>[];
  for (int i = 1; i < data[0].values.length; i++) {
    var spots = <FlSpot>[];
    for (int j = 0; j < data.length; j++) {
      spots.add(
          FlSpot(data[j].values[0].toDouble(), data[j].values[i].toDouble()));
    }
    LineChartBarData line = LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.5,
      dotData: FlDotData(
        show: false,
      ),
      colors: [colors[i - 1]],
    );
    lines.add(line);
  }
  return lines;
}

List<Indicator> indicators(List<String> labels) {
  if (labels == null) return [];

  final colors = <Color>[
    Color(0xffF72585),
    Color(0xff3F37C9),
    Color(0xff4895EF),
    Color(0xff4CC9F0),
    Colors.lightGreen,
  ];
  var ret = <Indicator>[];
  for (int i = 1; i < labels.length; i++) {
    ret.add(Indicator(
      color: colors[i - 1],
      text: labels[i],
    ));
  }
  return ret;
}
