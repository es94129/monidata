import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'indicator.dart';

class CpuUsagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16,),
              Text(
                "CPU usage",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.pink.withOpacity(0.1),
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
                                getTextStyles: (value) =>
                                  Theme.of(context).primaryTextTheme.bodyText2,
                              ),
                              leftTitles: SideTitles(
                                  showTitles: true,
                                  getTextStyles: (value) =>
                                    Theme.of(context).primaryTextTheme.bodyText2,
                                  getTitles: (value) {
                                    if (value.toInt() % 20 == 0)
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
                            lineBarsData: cpuLinesBarData()
                        )
                    ),
                  )
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Indicator(
                    color: const Color(0xffaa4cfc),
                    text: 'User',
                  ),
                  Indicator(
                    color: const Color(0xffb83b5e),
                    text: 'System',
                  ),
                ],
              ),
              SizedBox(height: 16,)
            ]
        )
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
          FlSpot(8, 73),
          FlSpot(9, 74),
          FlSpot(10, 65),
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
          FlSpot(8, 45),
          FlSpot(9, 42),
          FlSpot(10, 37),
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