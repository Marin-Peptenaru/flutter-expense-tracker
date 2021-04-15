import 'package:flutter/cupertino.dart';
import '../services/expense_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        child: Consumer<ExpenseManager>(builder: (context, manager, _) {
          var weeklyExpenses = manager.weeklyExpensesDistribution;
          return Container(
            decoration: BoxDecoration(color: Colors.black26),
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...weeklyExpenses.keys
                    .map((weekday) => _ChartBar(
                        weekday: weekday,
                        spendingPercentage: weeklyExpenses[weekday]!))
                    .toList(),
              ],
            ),
          );
        }));
  }
}

class _ChartBar extends StatelessWidget {
  final int weekday;
  final double spendingPercentage;

  static final _weekdayToString = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun'
  };

  const _ChartBar(
      {Key? key, required this.weekday, required this.spendingPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: Column(
          children: [
            // text to display the expense percentage
            Text('${(spendingPercentage * 100).toStringAsFixed(2)}%'),
            SizedBox(height: constraints.maxHeight * 0.05),
            //container for the bar
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              // stack to display the partially filled bar over an empty bar
              child: Stack(children: [
                //empty bar
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(200, 220, 200, 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                /*Partially filled bar, the height factor is the percentage
                received as argument.*/
                FractionallySizedBox(
                    heightFactor: spendingPercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ))
              ]),
            ),
            Text(
              _weekdayToString[weekday]!,
              style: DateTime.now().weekday == weekday
                  ? TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
          ],
        ),
      );
    });
  }
}

