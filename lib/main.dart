import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
        primaryColor: const Color(0xff262545),
        primaryColorDark: const Color(0xff201f39),
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Monitoring your cluster'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: const Color(0xff262545),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 16,),
            Text(
              "CPU usage",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff75729e),
                fontSize: 18
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                child: LineChart(
                    LineChartData(
                        minY: 0,
                        maxY: 100,
                        gridData: FlGridData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                              color: Color(0xff75729e),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                              color: Color(0xff75729e),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            getTitles: (value) {
                              if (value.toInt() == 0 || value.toInt() == 100)
                                return value.toInt().toString();
                              return '';
                            }
                          ),
                        ),
                        borderData: FlBorderData(
                          border: const Border(
                            bottom: BorderSide(
                              color: Color(0xff4e4965),
                              width: 4,
                            ),
                            left: BorderSide(
                              color: Color(0xff4e4965),
                              width: 4,
                            ),
                            right: BorderSide(
                              color: Colors.transparent,
                            ),
                            top: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        lineBarsData: cpuLinesBarData()
                    )
                ),
              )
            ),
            SizedBox(height: 16,),

          ]
        )
      ),

    );
  }

  List<LineChartBarData> cpuLinesBarData() {
    final LineChartBarData userLineBarData = LineChartBarData(
      spots: [
        FlSpot(1, 60),
        FlSpot(2, 58),
        FlSpot(3, 62),
        FlSpot(4, 76),
        FlSpot(5, 82),
        FlSpot(6, 71),
        FlSpot(7, 82),
      ],
      isCurved: true,
      colors: [Color(0x99aa4cfc)],
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: [Color(0x33aa4cfc)]
      )
    );
    final LineChartBarData systemLineBarData = LineChartBarData(
        spots: [
          FlSpot(1, 30),
          FlSpot(2, 28),
          FlSpot(3, 22),
          FlSpot(4, 26),
          FlSpot(5, 32),
          FlSpot(6, 41),
          FlSpot(7, 42),
        ],
        isCurved: true,
        colors: [Color(0x99b83b5e)],
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
            show: true,
            colors: [Color(0x33b83b5e)]
        )
    );
    return [userLineBarData, systemLineBarData];
  }
}
