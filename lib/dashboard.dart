import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final double _cpuCurrentUsage = 57;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 16,),
          Text(
            "System Overview",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
            ),
          ),
          SizedBox(height: 16,),
          Text(
            "CPU usage: $_cpuCurrentUsage %",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),
            textAlign: TextAlign.center,
          ),
          SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 12,
                disabledActiveTrackColor: Theme.of(context).primaryColor,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0), // hide thumb
              ),
              child: Slider(
                value: _cpuCurrentUsage,
                min: 0,
                max: 100,
                onChanged: null,
              ),
          ),
          SizedBox(height: 16,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    "Disk Read",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 6,),
                  Text(
                    "2.5 MB/s",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Disk Write",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
//                        color: Color(0xff75729e),
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 6,),
                  Text(
                    "0.2 MB/s",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}