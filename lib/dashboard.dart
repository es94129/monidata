import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final double _cpuCurrentUsage = 57;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff262545),
      child: Column(
        children: <Widget>[
          SizedBox(height: 16,),
          Text(
            "System Overview",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                fontSize: 24
            ),
          ),
          SizedBox(height: 16,),
          Text(
            "CPU usage: $_cpuCurrentUsage %",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff75729e),
                fontSize: 18
            ),
            textAlign: TextAlign.center,
          ),
          SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 12,
                disabledActiveTrackColor: Color(0x9900ad85),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0), // hide thumb
              ),
              child: Slider(
                value: _cpuCurrentUsage,
                min: 0,
                max: 100,
                onChanged: null,
              ),
          ),
        ],
      ),
    );
  }
}