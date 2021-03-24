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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          amount == other.amount &&
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ amount.hashCode ^ date.hashCode;

  @override
  String toString() {
    return 'Expense{id: $id, title: $title, amount: $amount, date: $date}';
  }
}
