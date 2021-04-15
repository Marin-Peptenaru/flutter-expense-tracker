import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_bar.dart';
import 'expense_list.dart';

import '../models/expense.dart';
import '../services/expense_manager.dart';
import '../utils/expense_type_colors.dart';

class ExpensesFilteredByType extends StatelessWidget with ExpenseTypeColorMapper {
  @override
  Widget build(BuildContext context) {
    var expenseType = ModalRoute.of(context)!.settings.arguments as ExpenseType;

    var expenseManager = Provider.of<ExpenseManager>(context);
    var expenses = expenseManager.expensesOfType(expenseType);
    var totalSpentForType = expenses.length > 0
        ? expenses
            .map((expense) => expense.amount)
            .reduce((total, amount) => total + amount)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(Expense.expenseTypeToString(expenseType)),
      ),
      body: Column(
        children: [
          ExpenseBar(
              value: totalSpentForType,
              capacity: expenseManager.amountSpent,
              color: expenseTypeColor[expenseType]!),
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ExpenseList(expenseManager.expensesOfType(expenseType))),
        ],
      ),
    );
  }
}
