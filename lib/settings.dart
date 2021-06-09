import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  bool criticalOn;
  bool anomalyOn;
  int windowMinutes = 2;

  TextStyle settingSectionStyle = TextStyle(
    color: Color(0xff212121),
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  TextStyle settingSpecifierStyle = TextStyle(
    color: Color(0xff616161),
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  Widget createSwitch(String specifier, bool value) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 250,
          child: Text(
            specifier,
            style: settingSpecifierStyle,
          ),
        ),
        Switch(
          value: value,
          onChanged: (bool newValue) {
            setState(() {
              criticalOn = newValue;
            });
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    criticalOn = anomalyOn = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x00ffffff),
          elevation: 0,
          title: Text('Settings'),
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Root Node', style: settingSectionStyle),
                Row(
                  children: <Widget>[
                    Text('IP Address', style: settingSpecifierStyle),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        initialValue: '101.201.236.53',
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Host Name', style: settingSpecifierStyle),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        initialValue: 'iZ2zefgt37lh254ur1mj5aZ',
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text('Notifications', style: settingSectionStyle),
                createSwitch('Critical Alerts', criticalOn),
                createSwitch('Anomaly Alerts', anomalyOn),
                SizedBox(
                  height: 40,
                ),
                Text('Charts', style: settingSectionStyle),
                Row(
                  children: <Widget>[
                    Text(
                      'Show recent',
                      style: settingSpecifierStyle,
                    ),
                    SizedBox(width: 40,),
                    DropdownButton(
                      value: windowMinutes,
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                      onChanged: (int newValue) {
                        setState(() {
                          windowMinutes = newValue;
                        });
                      },
                      items: <int>[1, 2, 5]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString() + ' min'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
