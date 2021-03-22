import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class DiskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff262545),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Text(
              "Disk I/O",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff75729e),
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 6.0),
              child: LineChart(LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.grey.withOpacity(0.8),
                  ),
                  touchCallback: (LineTouchResponse touchResponse) {},
                  handleBuiltInTouches: true,
                ),
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
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: diskLinesBarData(),
                betweenBarsData: [
                  BetweenBarsData(fromIndex: 0, toIndex: 1, colors: [Color(0x3317b978)]),
                  BetweenBarsData(fromIndex: 1, toIndex: 2, colors: [Color(0x33f57170)])
                ],
              )),
            )),
            SizedBox(height: 16,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(
                  color: const Color(0xff17b978),
                  text: 'Disk Read',
                ),
                Indicator(
                  color: const Color(0xfff57170),
                  text: 'Disk Write',
                ),
              ],
            ),
            SizedBox(height: 16,)
          ]),
    );
  }

  List<LineChartBarData> diskLinesBarData() {
    final LineChartBarData diskInData = LineChartBarData(
      spots: [
        FlSpot(1, 0.2),
        FlSpot(2, 0.8),
        FlSpot(3, 1.4),
        FlSpot(4, 2.5),
        FlSpot(5, 3.2),
        FlSpot(6, 1.2),
        FlSpot(7, 0.2),
        FlSpot(8, 0),
        FlSpot(9, 1.5),
        FlSpot(10, 2.5),
      ],
      isCurved: true,
      colors: [Color(0x9917b978)],
      dotData: FlDotData(
        show: false,
      ),
    );

    final LineChartBarData horizontal = LineChartBarData(
      spots: [
        FlSpot(1, 0),
        FlSpot(2, 0),
        FlSpot(3, 0),
        FlSpot(4, 0),
        FlSpot(5, 0),
        FlSpot(6, 0),
        FlSpot(7, 0),
        FlSpot(8, 0),
        FlSpot(9, 0),
        FlSpot(10, 0),
      ],
      isCurved: true,
      colors: [Colors.transparent],
      dotData: FlDotData(
        show: false,
      ),
    );

    final LineChartBarData diskOutData = LineChartBarData(
      spots: [
        FlSpot(1, -0.3),
        FlSpot(2, -0.2),
        FlSpot(3, -2.4),
        FlSpot(4, -2.3),
        FlSpot(5, -2.8),
        FlSpot(6, -1),
        FlSpot(7, -0.3),
        FlSpot(8, -0.4),
        FlSpot(9, -0.8),
        FlSpot(10, -1.2),
      ],
      isCurved: true,
      colors: [Color(0x99f57170)],
      dotData: FlDotData(
        show: false,
      ),
    );

    return [diskInData, horizontal, diskOutData];
  }
}
