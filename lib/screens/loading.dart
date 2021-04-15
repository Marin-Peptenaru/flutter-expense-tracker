import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loading Screen'),),
      body: Center(child: Text('Loading data ...'),)
    );
  }
}
