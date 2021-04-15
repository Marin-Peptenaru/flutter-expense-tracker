import '../../models/expense.dart';

extension DatabaseExpense on Expense{
  static final String _id = 'id';
  static final String _title = 'title';
  static final String _amount = 'amount';
  static final String _date = 'date';
  static final String _type = 'type';

  static String get createTableStatement =>
      'CREATE TABLE Expenses('
          '$_id INTEGER PRIMARY KEY,'
          '$_title TEXT,'
          '$_amount REAL,'
          '$_date DATETIME'
          '$_type TINYINT'
      ')';



}