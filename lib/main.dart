import 'package:expense_tracker/repositories/repository.dart';
import 'package:expense_tracker/services/expense_manager.dart';
import 'package:expense_tracker/widgets/expense_type_stats.dart';
import 'package:expense_tracker/widgets/expenses_type.dart';
import 'package:expense_tracker/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/validation/expense_validator.dart';
import 'models/expense.dart';
import 'widgets/homepage.dart';
import 'utils/route_names.dart';

void main() {
  //The UI of this application is thought only for portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget with PageRouter{
  ExpenseManager initExpenseManager() {
    var manager = ExpenseManager(
        Repository<int, Expense>(validator: ExpenseValidator()),
        budgetCap: 1000);
    return manager;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => initExpenseManager(),
      child: MaterialApp(
          title: 'Expense Tracker',
          theme: ThemeData.dark(),
          routes: {
            statistics: (_) => ExpenseStatsScreen(),
            expenseOfType: (_) => ExpensesFilteredByType(),
            settings: (_) => SettingsScreen(),
          },
          home: HomePageScreen(title: 'Expense Tracker Application')),
    );
  }
}
