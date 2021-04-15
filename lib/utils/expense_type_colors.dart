import 'package:flutter/material.dart';
import '../models/expense.dart';

mixin ExpenseTypeColorMapper {
  @protected
  final expenseTypeColor = {
    ExpenseType.other: Colors.grey,
    ExpenseType.food: Colors.orangeAccent,
    ExpenseType.bills: Colors.lightBlueAccent,
    ExpenseType.clothing: Colors.amberAccent,
    ExpenseType.subscriptions: Colors.redAccent,
    ExpenseType.recreation: Colors.purpleAccent,

  };
}