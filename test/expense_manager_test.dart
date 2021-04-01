import '../lib/models/validation/validator.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/repositories/repository.dart';
import '../lib/services/expense_manager.dart';
import '../lib/models/validation/expense_validator.dart';

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
          title: "e1", amount: 10, date: DateTime.now().subtract(Duration(days: 2)));
      var e3 = manager.addExpense(
          title: "e1", amount: 10, date: DateTime.now().subtract(Duration(days: 7)));
      var expenses = manager.expensesFromTheLastDays(7);
      assert(expenses.isNotEmpty);
      assert(e1.isPresent);
      assert(e2.isPresent);
      assert(e3.isPresent);
      assert(expenses.contains(e1.value));
      assert(expenses.contains(e2.value));
      assert(!expenses.contains(e3.value));

    });

    test('weeklyExpensesReport, expenses added, report hashMap has correct values', (){
      var e1 = manager.addExpenseNow(title: "e1", amount: 50).value;
      var e2 = manager.addExpense(
          title: "e1", amount: 150, date: DateTime.now().subtract(Duration(days: 1))).value;

      var weekday1 = e1.date.weekday;
      var weekday2 = e2.date.weekday;
      var weeklyExpensesDistribution = manager.weeklyExpensesDistribution;
      for(var weekday = DateTime.monday; weekday <= DateTime.sunday; ++weekday){
        if(weekday == weekday1) assert(weeklyExpensesDistribution[weekday] == 0.25);
        else if(weekday == weekday2) assert(weeklyExpensesDistribution[weekday] == 0.75);
        else assert(weeklyExpensesDistribution[weekday] == 0.0);
      }
    });
  });
}
