import 'package:expense_tracker/services/expense_manager.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'expense_card.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseManager>(builder: (context, expenseManager, _) {
      var expenses = expenseManager.allExpenses;
      return expenses.isEmpty
          ? Column(
              children: [
                Text('No expenses yet.'),
                SizedBox(height: 20,),
                Container(
                    height: 300,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover)),
              ],
            )
          : Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ExpenseCard(expense: expenses[index]);
                },
                itemCount: expenseManager.allExpenses.length,
              ),
            );
    });
  }
}
