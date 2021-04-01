import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../services/expense_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseChart extends StatelessWidget {
  static final _weekdayToString = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun'
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Consumer<ExpenseManager>(builder: (context, manager, _) {
        var weeklyExpenses = manager.weeklyExpensesDistribution;
        return Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...weeklyExpenses.keys
                  .map((weekday) => _ChartBar(
                      weekdayLabel: _weekdayToString[weekday]!,
                      spendingPercentage: weeklyExpenses[weekday]!))
                  .toList(),
            ],
          ),
        );
      }),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final String weekdayLabel;
  final double spendingPercentage;

  const _ChartBar(
      {Key? key, required this.weekdayLabel, required this.spendingPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: Column(
        children: [
          Text('${(spendingPercentage * 100).toStringAsFixed(2)}%'),
          SizedBox(height: 4),
          _PercentageBar(percentage: spendingPercentage),
          Text(weekdayLabel),
        ],
      ),
    );
  }
}

class _PercentageBar extends StatelessWidget {
  final double percentage;

  const _PercentageBar({Key? key, required this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 10,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            color: Color.fromRGBO(200, 220, 200, 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        FractionallySizedBox(heightFactor: percentage,
        child:  Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(20),
          ),
        )
        )
      ]),
    );
  }
}
