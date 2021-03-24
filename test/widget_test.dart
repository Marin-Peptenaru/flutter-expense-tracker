// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:expense_tracker/domain/expense.dart';
import 'package:expense_tracker/domain/validation/expense_validator.dart';
import 'package:expense_tracker/domain/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';

void main() {
  group('Test Expense domain entity', (){

    ExpenseValidator _validator = ExpenseValidator();

    test('ExpenseValidator, '
        'create Expense object with valid data, object passes validation', (){
      Expense expense = Expense(id: 1, title: 'Shopping',
          amount: 10, date: DateTime(2001, 10, 10));

      _validator.validate(expense);
    });

    test('ExpenseValidator, create Expense object with invalid data, ValidationException thrown', (){
      try{
        Expense expense = Expense(id: 1, title: 'Shopping',
            amount: -50, date: DateTime(2023, 12, 12));
        _validator.validate(expense);
      }on Exception catch (e){
        assert(e is ValidationException);
      }
    });

  });
}
