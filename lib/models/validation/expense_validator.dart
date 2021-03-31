import '../expense.dart';
import './validator.dart';

class ExpenseValidator extends Validator<Expense>{

  ExpenseValidator();

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
      date.isBefore(DateTime.now()) || date.isAtSameMomentAs(DateTime.now())
          ? ""
          : "Purchase date must be valid.";



}