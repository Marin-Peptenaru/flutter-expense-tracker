import 'package:expense_tracker/repositories/repository.dart';
import 'package:expense_tracker/services/expense_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/validation/expense_validator.dart';
import 'models/expense.dart';
import 'widgets/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ExpenseManager _dummyData() {
    var manager = ExpenseManager(
        Repository<int, Expense>(validator: ExpenseValidator()),
        budgetCap: 1000);
    var today = DateTime.now();
    manager.addExpense(
        title: "e1", amount: 50, date: today.subtract(Duration(days: 2)));
    manager.addExpense(title: "e2", amount: 150, date: today.subtract(Duration(days: 2)));
    manager.addExpense(title: "e3", amount: 100, date:today.subtract(Duration(days: 1)));
    manager.addExpense(title: "e4", amount: 75, date: today.subtract(Duration(days: 3)));
    manager.addExpense(title: "e5", amount: 30, date: today.subtract(Duration(days: 4)));
    manager.addExpense(title: "e6", amount: 210, date: today.subtract(Duration(days: 6)));
    manager.addExpense(title: "e7", amount: 25, date: today);
    manager.addExpense(title: "e6", amount: 300, date: today.subtract(Duration(days: 10)));
    return manager;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
          create: (context) => _dummyData(),
          child: MyHomePage(title: 'Expense Tracker Application')),
    );
  }
}
