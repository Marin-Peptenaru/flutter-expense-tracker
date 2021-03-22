import 'package:flutter/material.dart';

class Expense {
  final int id;
  final String title;
  final double amount;
  final DateTime date;

  Expense(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});
}
