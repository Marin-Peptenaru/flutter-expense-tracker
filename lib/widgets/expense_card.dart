import 'dart:math';

import '../models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  
  final Expense _expense;
  
  ExpenseCard({required Expense expense}): _expense = expense;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
        child:
    Row(
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.lightGreenAccent),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              '\$${_expense.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightGreenAccent),)
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(_expense.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold
          ),),
          Text(DateFormat('E dd MMM yyyy').format(_expense.date), style: TextStyle(color: Colors.grey),)
        ],)
      ],
    ));
  }
}
