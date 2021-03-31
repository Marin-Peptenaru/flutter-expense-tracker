import 'dart:developer';

import 'package:expense_tracker/services/expense_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends StatefulWidget {
  ExpenseManager _expenseManager;

  ExpenseForm(ExpenseManager expenseManager) : _expenseManager = expenseManager;

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleInputController = TextEditingController();

  final _amountInputController = TextEditingController();

  void _submitExpense() {
    var expenseTitle = _titleInputController.text;
    var amount = _amountInputController.text;
    if (expenseTitle.isNotEmpty && amount.isNotEmpty)
      widget._expenseManager.addExpenseNow(
          title: expenseTitle, amount: double.parse(amount));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleInputController,
                onSubmitted: (_) => _submitExpense(),
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _amountInputController,
                decoration: InputDecoration(labelText: 'Amount'),
                onSubmitted: (_) => _submitExpense(),
                keyboardType: TextInputType.number,
              ),
              TextButton(
                  child: Text('Add expense'),
                  onPressed: _submitExpense,
                  style: TextButton.styleFrom(primary: Colors.lightGreenAccent))
            ],
          ),
        ));
  }
}
