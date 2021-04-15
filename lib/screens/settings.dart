import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/expense_manager.dart';
import '../utils/user_preferences_manager.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _budgetField = TextEditingController();
  double _budget = 0.0;

  void _setNewBudget(ExpenseManager expenseManger) {
    _budget = double.parse(_budgetField.text);
    setState(() {
      expenseManger.setBudgetCap(_budget);
    });
    UserPreferencesManager.setUserBudget(_budget);
  }

  @override
  Widget build(BuildContext context) {
    var expenseManager = Provider.of<ExpenseManager>(context);
    _budget = expenseManager.budgetCap;
    _budgetField.text = _budget.toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Budget'),
              controller: _budgetField,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _setNewBudget(expenseManager),
            )
          ],
        ),
      ),
    );
  }
}
