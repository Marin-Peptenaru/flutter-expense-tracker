import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'expense_card.dart';
import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> _expenses;

  ExpenseList(List<Expense> expenses) : _expenses = expenses;

  @override
  Widget build(BuildContext context) {
    return _expenses.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Text('No expenses yet.'),
                Container(
                    height: constraints.maxHeight * 0.6,
                    margin: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.1),
                    child: Image.asset('assets/images/waiting.png')),
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return ExpenseCard(expense: _expenses[index]);
            },
            itemCount: _expenses.length,
          );
  }
}
