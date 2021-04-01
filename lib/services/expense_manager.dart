import 'dart:collection';

import 'package:optional/optional.dart';
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

  Optional<Expense> addExpense(
      {required String title, required double amount, required DateTime date}) {
    var expense =
    Expense(id: idManager.newID, title: title, amount: amount, date: date);
    var addedExpense = _expenseRepository.save(expense);

    addedExpense.ifPresent((expense) {
      _budget.addSpentAmount(expense.amount);
      notifyListeners();
    });

    return addedExpense;
  }

  Optional<Expense> addExpenseNow(
      {required String title, required double amount}) =>
      addExpense(title: title, amount: amount, date: DateTime.now());

  double get budgetCap => _budget.budgetCap;

  double get amountSpent => _budget._amountSpent;

  double get percentageSpent => _budget.percentageSpent;

  List<Expense> get allExpenses => _expenseRepository.getAll();

  List<Expense> expensesFromTheLastDays(int days) =>
      _expenseRepository.getAll().where((expense) =>
      DateTime
          .now()
          .difference(expense.date)
          .inDays < days).toList();


  /*
   As a week the last 7 days are considered, including the current day.
   returns a map where the keys are the weekdays ( 1 - monday, 7 - sunday)
   and the values are doubles representing how much of the total amount spent during
   the last week was spent on each weekday.
   E.g. map(DateTime.monday) = 0.5 if on mondays was spent 50% of the amount
   spent in the past 7 days.
   */
  Map<int, double> get weeklyExpensesDistribution{
    var distribution = HashMap<int, double>();
    var totalSpentAmount = 0.0;
    for (var i = DateTime.monday; i <= DateTime.sunday; ++i) {
      distribution[i] = 0;
    }

    expensesFromTheLastDays(7).forEach((expense) {
      distribution.update(expense.date.weekday, (amountSpent) => amountSpent + expense.amount);
      totalSpentAmount += expense.amount;
    });

    distribution.updateAll((weekday, spentAmount) => spentAmount / totalSpentAmount);
    return distribution;
  }


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
