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
                fontSize: 20
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
                        color: Color(0xff75729e),
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 6,),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff75729e),
                            fontSize: 16
                        ),
                      children: <TextSpan>[
                        TextSpan(
                            text: "2.5",
                            style: TextStyle(
                              color: Color(0xff00ad85),
                                fontSize: 20,
                              fontWeight: FontWeight.bold
                            )
                        ),
                        TextSpan(text: " MB/s")
                      ]
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
                        color: Color(0xff75729e),
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 6,),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff75729e),
                            fontSize: 16
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "0.2",
                              style: TextStyle(
                                  color: Color(0xff00ad85),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          TextSpan(text: " MB/s")
                        ]
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