import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff262545),
      child: Column(
        children: <Widget>[
          SizedBox(height: 16,),
          Text(
            "CPU usage: 58%",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff75729e),
                fontSize: 18
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}