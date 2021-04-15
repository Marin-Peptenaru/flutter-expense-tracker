import 'dart:math';

import 'package:expense_tracker/models/expense.dart';

import '../lib/models/validation/validator.dart';
import '../lib/repositories/repository.dart';
import '../lib/services/expense_manager.dart';
import '../lib/models/validation/expense_validator.dart';
import '../lib/models/expense.dart' as expense;

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseManager class tests', () {
    var manager = ExpenseManager(Repository(validator: ExpenseValidator()),
        budgetCap: 200);
    setUp(() {
      manager = ExpenseManager(Repository(validator: ExpenseValidator()),
          budgetCap: 200);
    });

    test(
        'addExpense, valid expense, expense added correctly and budget spent amount and percentage updated,',
        () {
      var addedExpense = manager.addExpenseNow(title: "exp", amount: 100);
      assert(addedExpense.isPresent);
      addedExpense.ifPresent((expense) {
        assert(manager.amountSpent == expense.amount);
        assert(manager.percentageSpent == expense.amount / manager.budgetCap);
        assert(manager.allExpenses.contains(expense));
      });
    });

    test('addExpense, invalid expense, ValidationException thrown', () {
      try {
        manager.addExpenseNow(title: "exp", amount: -200);
        assert(false);
      } on Exception catch (e) {
        assert(e is ValidationException);
        assert(manager.amountSpent == 0);
        assert(manager.percentageSpent == 0);
      }
    });

    test('allExpenses, no expenses, empty list returned', () {
      var expenses = manager.allExpenses;
      assert(expenses.isEmpty);
    });

    test('allExpenses,expenses inserted, list with all added expenses returned',
        () {
      var e1 = manager.addExpenseNow(title: "exp1", amount: 100);
      var e2 = manager.addExpenseNow(title: "exp2", amount: 100);
      var expenses = manager.allExpenses;
      assert(expenses.isNotEmpty);
      assert(expenses.length == 2);
      assert(e1.isPresent);
      assert(e2.isPresent);
      e1.ifPresent((exp1) {
        assert(expenses.contains(exp1));
      });
      e2.ifPresent((exp2) {
        assert(expenses.contains(exp2));
      });
    });

    test(
        'expensesFromTheLast7Days, expenses added, a list with only expenses from the last 7 days is returned',
        () {
      var e1 = manager.addExpenseNow(title: "e1", amount: 10);
      var e2 = manager.addExpense(
          title: "e1",
          amount: 10,
          date: DateTime.now().subtract(Duration(days: 2)));
      var e3 = manager.addExpense(
          title: "e1",
          amount: 10,
          date: DateTime.now().subtract(Duration(days: 7)));
      var expenses = manager.expensesFromTheLastDays(7);
      assert(expenses.isNotEmpty);
      assert(e1.isPresent);
      assert(e2.isPresent);
      assert(e3.isPresent);
      assert(expenses.contains(e1.value));
      assert(expenses.contains(e2.value));
      assert(!expenses.contains(e3.value));
    });

    test(
        'weeklyExpensesReport, expenses added, report hashMap has correct values',
        () {
      var e1 = manager.addExpenseNow(title: "e1", amount: 50).value;
      var e2 = manager
          .addExpense(
              title: "e1",
              amount: 150,
              date: DateTime.now().subtract(Duration(days: 1)))
          .value;

      var weekday1 = e1.date.weekday;
      var weekday2 = e2.date.weekday;
      var weeklyExpensesDistribution = manager.weeklyExpensesDistribution;
      for (var weekday = DateTime.monday;
          weekday <= DateTime.sunday;
          ++weekday) {
        if (weekday == weekday1)
          assert(weeklyExpensesDistribution[weekday] == 0.25);
        else if (weekday == weekday2)
          assert(weeklyExpensesDistribution[weekday] == 0.75);
        else
          assert(weeklyExpensesDistribution[weekday] == 0.0);
      }
    });

    test(
        'deleteExpense, expense exists, deleted expense returned and budget update accordingly.',
        () {
      var e1 = manager.addExpenseNow(title: "e1", amount: 100).value;
      var e2 = manager.addExpenseNow(title: "e2", amount: 100).value;

      var deletedE2 = manager.deleteExpense(e2.id);

      var expenses = manager.allExpenses;
      assert(deletedE2.contains(e2));
      assert(!expenses.contains(e2));
      assert(manager.amountSpent == e1.amount);
      assert(manager.percentageSpent == e1.amount / manager.budgetCap);
    });

    test(
        'deleteExpense, expense does not exist, empty optional returned, '
        'stored expense and budget data remain unchanged', () {
      var e1 = manager.addExpenseNow(title: "expense", amount: 100).value;

      var deletedExpense = manager.deleteExpense(300);
      assert(deletedExpense.isEmpty);

      var expenses = manager.allExpenses;
      assert(expenses.length == 1);
      assert(expenses.contains(e1));

      assert(manager.amountSpent == e1.amount);
      assert(manager.percentageSpent == e1.amount / manager.budgetCap);
    });

    test(
        'expensesOfType, expenses of given type exist, list with all the expenses of that type returned',
        () {
      manager.addExpenseNow(title: "exp", amount: 100);
      var e1 = manager
          .addExpenseNow(
              title: "exp1", amount: 100, type: expense.ExpenseType.food)
          .value;
      var e2 = manager
          .addExpenseNow(
              title: "exp2", amount: 100, type: expense.ExpenseType.food)
          .value;
      manager.addExpenseNow(
          title: "exp", amount: 100, type: expense.ExpenseType.clothing);

      var foodExpenses = manager.expensesOfType(expense.ExpenseType.food);
      assert(foodExpenses.length == 2);
      foodExpenses.forEach((expense) => print(expense));
      assert(foodExpenses.contains(e1));
      assert(foodExpenses.contains(e2));
    });

    test(
        'amountSpentForEachType, expenses of different types exist, map with correct values returned',
        () {
      var e1 = manager
          .addExpenseNow(
              title: "exp1", amount: 100, type: expense.ExpenseType.food)
          .value;
      var e2 = manager
          .addExpenseNow(
              title: "exp2", amount: 200, type: expense.ExpenseType.clothing)
          .value;
      var e3 = manager
          .addExpenseNow(
              title: "exp3", amount: 100, type: expense.ExpenseType.food)
          .value;
      var e4 = manager
          .addExpenseNow(
              title: "exp4", amount: 150, type: expense.ExpenseType.bills)
          .value;

      var amountSpentForType = manager.amountSpentForEachType;

      assert(amountSpentForType[expense.ExpenseType.food] ==
          e1.amount + e3.amount);
      assert(amountSpentForType[expense.ExpenseType.clothing] == e2.amount);
      assert(amountSpentForType[expense.ExpenseType.bills] == e4.amount);

      var presentTypes = [
        expense.ExpenseType.food,
        expense.ExpenseType.clothing,
        expense.ExpenseType.bills
      ];


      expense.ExpenseType.values
          .where((expenseType) => !presentTypes.contains(expenseType))
          .forEach((expenseType) {
            print(expenseType);
            assert(amountSpentForType[expenseType] == 0);
          });
    });
  });
}
