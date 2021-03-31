import 'package:flutter/material.dart';

class ExpenseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
        width: double.infinity,
        child: Card(
            color: Colors.blue, child: Text('Chart'), elevation: 5)
    );
  }
}
