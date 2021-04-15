import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/validation/expense_validator.dart';
import '/screens/loading.dart';
import '/repositories/repository.dart';
import '/services/expense_manager.dart';
import '/utils/user_preferences_manager.dart';
import 'screens/expense_type_stats.dart';
import 'screens/expenses_type.dart';
import 'screens/settings.dart';
import 'models/expense.dart';
import 'screens/homepage.dart';
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

class MyApp extends StatelessWidget with PageRouter {
  Future<ExpenseManager> initExpenseManager() async {
    final budget = UserPreferencesManager.getUserBudget();
    var manager = ExpenseManager(
        Repository<int, Expense>(validator: ExpenseValidator()),
        budgetCap: await budget);
    return manager;
  }

  Widget _actualApplication(ExpenseManager expenseManager) {
    return ChangeNotifierProvider(
      create: (context) => expenseManager,
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

  Widget _loadingScreen() {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData.dark(),
      home: LoadingScreen(),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExpenseManager>(
      future: initExpenseManager(),
      builder: (context, snapshot) => snapshot.hasData
          ? _actualApplication(snapshot.requireData)
          : _loadingScreen(),
    );
  }
}
