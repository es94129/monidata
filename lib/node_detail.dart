import 'package:flutter/material.dart';

class NodeDetailPage extends StatefulWidget {
  final String hostname;

  NodeDetailPage({Key key, this.hostname}) : super(key: key);

  @override
  _NodeDetailState createState() => _NodeDetailState();
}

class _NodeDetailState extends State<NodeDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Text('Hello'),
    );
  }
}
