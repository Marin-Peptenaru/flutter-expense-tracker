import 'dart:developer';

import 'package:expense_tracker/services/expense_manager.dart';
import '../models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//TODO: solve overflow issue caused by soft keyboard
class ExpenseForm extends StatefulWidget {
  ExpenseManager _expenseManager;

  ExpenseForm(ExpenseManager expenseManager) : _expenseManager = expenseManager;

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleInputController = TextEditingController();

  final _amountInputController = TextEditingController();

  DateTime _pickedDate = DateTime.now();

  ExpenseType _expenseType = ExpenseType.other;

  @override
  void initState() {
    super.initState();
    _pickedDate = DateTime.now();
  }

  void _submitExpense() {
    var expenseTitle = _titleInputController.text;
    var amount = _amountInputController.text;
    if (expenseTitle.isNotEmpty && amount.isNotEmpty)
      widget._expenseManager.addExpense(
          title: expenseTitle,
          amount: double.parse(amount),
          type: _expenseType,
          date: _pickedDate);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      setState(() {
        _pickedDate = selectedDate ?? _pickedDate ;
      });
    });
  }

  Widget _expenseTypeDropDown() {
    return DropdownButton<ExpenseType>(
        value: _expenseType,
        onChanged: (ExpenseType? selectedType) {
          setState(() {
            _expenseType = selectedType == null ? _expenseType : selectedType;
          });
        },
        items: ExpenseType.values
            .map<DropdownMenuItem<ExpenseType>>((type) => DropdownMenuItem(
                value: type, child: Text(Expense.expenseTypeToString(type))))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titleInputController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _amountInputController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(DateFormat.yMMMEd().format(_pickedDate)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      child: Text('Choose another date'),
                      onPressed: _showDatePicker,
                      style: TextButton.styleFrom(primary: Colors.greenAccent),
                    )
                  ],
                ),
                _expenseTypeDropDown(),
                ElevatedButton(
                    child: Text('Add expense'),
                    onPressed: _submitExpense,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent,
                        onPrimary: Colors.black54)),
              ],
            ),
          )),
    );
  }
}
