import './int_id_manager.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../repositories/repository.dart';

class ExpenseManager with ChangeNotifier {
  late final _Budget _budget;
  final Repository<int, Expense> _expenseRepository;
  final idManager = IntIDManager(initialCounter: 0);

  ExpenseManager(Repository<int, Expense> repository,
      {required double budgetCap})
      : assert(budgetCap > 0),
        _budget = _Budget(budgetCap),
        _expenseRepository = repository;

  void _spendFromBudget(double amount) => _budget.addSpentAmount(amount);

  void addExpense(
      {required String title, required double amount, required DateTime date}) {
    var expense =
        Expense(id: idManager.newID, title: title, amount: amount, date: date);
    _expenseRepository.save(expense);
    _spendFromBudget(amount);
    notifyListeners();
  }

  void addExpenseNow(
          {required String title, required double amount}) =>
      addExpense(title: title, amount: amount, date: DateTime.now());

  double get budgetCap => _budget.budgetCap;

  double get amountSpent => _budget._amountSpent;

  double get percentageSpent => _budget.percentageSpent;

  List<Expense> get allExpenses => _expenseRepository.getAll();
}

class _Budget {
  final double budgetCap;
  var _amountSpent = 0.0;

  _Budget(this.budgetCap);

  _Budget withCap(double cap) {
    var newBudget = _Budget(cap);
    newBudget._amountSpent = this._amountSpent;
    return newBudget;
  }

  double get percentageSpent => _amountSpent / budgetCap;

  void addSpentAmount(double amount) => _amountSpent += amount;
}
