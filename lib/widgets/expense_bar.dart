import 'package:flutter/material.dart';

class ExpenseBar extends StatelessWidget {
  final double value;
  final double capacity;
  final Color color;

  const ExpenseBar(
      {required this.value, required this.capacity, required this.color});

  @override
  Widget build(BuildContext context) {
    var percentage = capacity > 0 ? value /capacity * 100 : 0.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FittedBox(
          child: Text(
            '\$${value.toStringAsFixed(2)}/\$${capacity.toStringAsFixed(2)} | ${percentage.toStringAsFixed(2)}%',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        LinearProgressIndicator(
          value: percentage/100,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        )
      ],
    );
  }
}
