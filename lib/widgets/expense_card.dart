import 'dart:math';
import 'package:expense_tracker/utils/expense_type_colors.dart';

import '../models/expense.dart';
import '../services/expense_manager.dart';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget with ExpenseTypeColorMapper {
  final Expense _expense;

  ExpenseCard({required Expense expense}) : _expense = expense;

  void _deleteExpense(BuildContext context) {
    var expenseManager = Provider.of<ExpenseManager>(context, listen: false);
    expenseManager.deleteExpense(_expense.id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black12,
              Colors.black38,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: expenseTypeColor[_expense.type],
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: FittedBox(
                  child: Text(
                    '\$${_expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  ),
                ),
              )),
          title: Text(_expense.title + ": " + _expense.typeToString),
          subtitle: Text(DateFormat.yMMMMEEEEd().format(_expense.date)),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteExpense(context)),
        ),
      ),
    );
  }
}
