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
  String viewingChart = "system.cpu";
  String chartUnit = "%";

  Timer timer;
  int windowSeconds = 120;
  int windowOffset = 0;

  int metricOrAnomalyChoiceIndex;

  final nameToChart = {
    'CPU': {'name': 'system.cpu', 'unit': '%', 'interval': 20.0},
    'Load': {'name': 'system.load', 'unit': 'processes', 'interval': 0.1},
    'Processes': {'name': 'system.processes', 'unit': 'processes', 'interval': 5.0},
    'System RAM': {'name': 'system.ram', 'unit': 'GB', 'interval': 5.0},
    'Network traffic': {
      'name': 'system.ip',
      'unit': 'megabits/s',
      'interval': 0.5
    },
  };

  @override
  void initState() {
    super.initState();
    metricOrAnomalyChoiceIndex = 0;
    futureChart = fetchChart(widget.hostname, windowSeconds, 0, 'system.cpu');
    timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              futureChart = fetchChart(
                  widget.hostname, windowSeconds, windowOffset, viewingChart);
            }));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x00ffffff),
        elevation: 0,
        title: Text(widget.hostname),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.home_filled),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              }),
        ],
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
                        chartUnit = nameToChart[newValue]['unit'];
                        windowOffset = 0;
                        metricOrAnomalyChoiceIndex = 0;
                        viewingChart = nameToChart[newValue]['name'];
                        futureChart = fetchChart(
                            widget.hostname, windowSeconds, 0, viewingChart);
                      });
                    },
                    items: <String>[
                      'CPU',
                      'Load',
                      'Processes',
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
                  child: GestureDetector(
                      onHorizontalDragUpdate: (dragDetails) {
                        setState(() {
                          double primaryDelta = dragDetails.primaryDelta ?? 0.0;
                          if (primaryDelta != 0) {
                            if (primaryDelta.isNegative) {
                              if (windowOffset > 0) {
                                windowOffset -= (windowSeconds * 0.01).toInt();
                              }
                            } else {
                              windowOffset += (windowSeconds * 0.01).toInt();
                            }
                            futureChart = fetchChart(widget.hostname,
                                windowSeconds, windowOffset, viewingChart);
                          }
                        });
                      },
                      child: FutureBuilder<Chart>(
                        future: futureChart,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return LineChart(
                              LineChartData(
                                lineBarsData: (metricOrAnomalyChoiceIndex == 0)
                                    ? barDataLinesMetrics(
                                        snapshot.data.data, chartName)
                                    : barDataLinesProbs(
                                        snapshot.data.data,
                                        snapshot.data.labels,
                                        nameToChart[chartName]['name']),
                                minY: chartName == 'CPU' ||
                                        metricOrAnomalyChoiceIndex == 1
                                    ? 0
                                    : null,
                                maxY: chartName == 'CPU' ||
                                        metricOrAnomalyChoiceIndex == 1
                                    ? 100
                                    : null,
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
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
                                      getTextStyles: (value) =>
                                          Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText2,
                                      getTitles: (timestamp) {
                                        if ((timestamp / 5).floor() * 5 % 60 ==
                                            0) {
                                          var datetime = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  timestamp.toInt() * 1000);
                                          return TimeOfDay.fromDateTime(
                                                  datetime)
                                              .format(context);
                                        }

                                        return '';
                                      }),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText2,
                                    interval: metricOrAnomalyChoiceIndex == 1
                                        ? 20.0
                                        : nameToChart[chartName]['interval'],
                                    reservedSize: 40,
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return CircularProgressIndicator();
                        },
                      ))),
              Text(
                '(' + (metricOrAnomalyChoiceIndex == 1? '%' : chartUnit) + ')',
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
                      children: indicators(
                          snapshot.data.labels, metricOrAnomalyChoiceIndex),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return SizedBox(
                    height: 1,
                  );
                },
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                  child: Wrap(
                children: [
                  ChoiceChip(
                    label: Text(
                      'Metrics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: metricOrAnomalyChoiceIndex == 0,
                    onSelected: (value) {
                      metricOrAnomalyChoiceIndex = value ? 0 : -1;
                      viewingChart = nameToChart[chartName]['name'];
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ChoiceChip(
                    label: Text('Anomaly Probability',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    selected: metricOrAnomalyChoiceIndex == 1,
                    onSelected: (value) {
                      metricOrAnomalyChoiceIndex = value ? 1 : -1;
                      viewingChart = 'anomalies.probability';
                    },
                  ),
                ],
              ))
            ],
          )),
    );
  }
}

Future<Chart> fetchChart(
    String hostname, int time, int before, String chartName) async {
  final response = await http.get(
      Uri.http("101.201.236.53:19999", "/host/" + hostname + "/api/v1/data", {
    "chart": chartName,
    "after": "-" + time.toString(),
    "before": "-" + before.toString(),
    "options": "nonzero"
  }));
  if (response.statusCode == 200) {
    return Chart().fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load info");
  }
}

List<LineChartBarData> barDataLinesMetrics(List<Data> data, String chartName) {
  if (data[0].values.length > 5) return null;
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
      if (chartName == 'System RAM' || chartName == 'Network traffic')
        spots.add(FlSpot(
            data[j].values[0].toDouble(), data[j].values[i].toDouble() / 1024));
      else
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

List<LineChartBarData> barDataLinesProbs(
    List<Data> data, List<String> labels, String chart) {
  int index = 0;
  for (int i = 0; i < labels.length; i++) {
    if (chart + '_prob' == labels[i]) {
      index = i;
      break;
    }
  }
  final color = Color(0xff4895EF);
  var lines = <LineChartBarData>[];
  var spots = <FlSpot>[];
  for (int j = 0; j < data.length; j++) {
    if (data[j].values[index] == null)
      continue;
    spots.add(
        FlSpot(data[j].values[0].toDouble(), data[j].values[index].toDouble()));
  }

  LineChartBarData line = LineChartBarData(
    spots: spots,
    isCurved: true,
    curveSmoothness: 0.5,
    dotData: FlDotData(
      show: false,
    ),
    colors: [color],
  );
  lines.add(line);

  return lines;
}

List<Indicator> indicators(
    List<String> labels, int metricOrAnomalyChoiceIndex) {
  if (labels == null || labels.length > 6) return [];

  final colors = <Color>[
    Color(0xffF72585),
    Color(0xff3F37C9),
    Color(0xff4895EF),
    Color(0xff4CC9F0),
    Colors.lightGreen,
  ];
  var ret = <Indicator>[];
  if (metricOrAnomalyChoiceIndex == 1) {
    ret.add(Indicator(
      color: colors[2],
      text: 'Probability',
    ));
  } else {
    for (int i = 1; i < labels.length; i++) {
      ret.add(Indicator(
        color: colors[i - 1],
        text: labels[i],
      ));
    }
  }
  return ret;
}
