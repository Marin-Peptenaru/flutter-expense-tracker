import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/expense_manager.dart';
import '../models/expense.dart';
import '../utils/expense_type_colors.dart';
import '../utils/route_names.dart';

class ExpenseStatsScreen extends StatelessWidget
    with ExpenseTypeColorMapper, PageRouter {

  late Map<ExpenseType, double> _amountSpentPerType;
  late ExpenseManager _expenseManager;

  Widget _expenseTypeStatsCard(BuildContext context, ExpenseType type) {
    return InkWell(
      onTap: () {
        if (_amountSpentPerType[type]! > 0)
          Navigator.of(context).pushNamed(expenseOfType, arguments: type);
      },
      child: Card(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Expense.expenseTypeToString(type),
              style: TextStyle(color: expenseTypeColor[type])),
          Text('Amount: \$${_amountSpentPerType[type]!.toStringAsFixed(2)}'),
          Text('Count: ${_expenseManager.expensesOfType(type).length}'),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    _expenseManager = Provider.of<ExpenseManager>(context);
    var hasExpenses = _expenseManager.allExpenses.length > 0;
    _amountSpentPerType = _expenseManager.amountSpentForEachType;
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Center(
        child: Column(
          children: [
            if (hasExpenses)
              Expanded(
                flex: 1,
                child: PieChart(
                  PieChartData(
                      sections: ExpenseType.values
                          .where((type) => _amountSpentPerType[type]! > 0)
                          .map((type) => PieChartSectionData(
                                value: _amountSpentPerType[type],
                                color: expenseTypeColor[type],
                                title: Expense.expenseTypeToString(type),
                                showTitle: true,
                              ))
                          .toList()),
                ),
              ),
            Expanded(
              flex: 1,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                children: ExpenseType.values
                    .map((type) => _expenseTypeStatsCard(context, type))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
