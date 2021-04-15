import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesManager {
  static double _defaultBudget = 200;

  // _currentBudget will be initialised when calling getUserBudget()
  // when the app starts
  static late double _currentBudget;

  static String _budget = 'budget';

  static Future<void> setUserBudget(double newBudget) async{
    if(_currentBudget == newBudget) return;
    SharedPreferences.getInstance()
        .then((preferences) => preferences.setDouble(_budget, newBudget));
  }


  static Future<double> getUserBudget() async {
    final userPreferences = await SharedPreferences.getInstance();
    _currentBudget = userPreferences.getDouble(_budget) ?? _defaultBudget;
    return _currentBudget;
  }
}
