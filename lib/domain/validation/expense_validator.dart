import 'package:expense_tracker/domain/expense.dart';
import 'package:expense_tracker/domain/validation/validator.dart';

class ExpenseValidator extends Validator<Expense>{

  @override
  void validate(Expense expense) {
    initValidation();
    appendToErrorMessage( _validateAmount(expense.amount) );
    appendToErrorMessage( _validateDate(expense.date) );
    throwIfAnyErrors();
  }

  String _validateAmount(double amount) =>
      amount > 0? "" : "Spent amount must be strictly positive";

  String _validateDate(DateTime date) =>
      date.isBefore(DateTime.now())? "" : "Purchase date must be valid.";



}