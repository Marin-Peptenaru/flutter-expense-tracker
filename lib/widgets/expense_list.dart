import 'package:expense_tracker/services/expense_manager.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import 'package:flutter/material.dart';

import 'expense_card.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseManager>(builder: (context, expenseManager, _) {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ExpenseCard(expense: expenseManager.allExpenses[index]);
          },
          itemCount: expenseManager.allExpenses.length,
        ),
      );
    });
  }
}
