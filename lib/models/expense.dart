import '../models/base_entity.dart';
import '../utils/string_extension.dart';

enum ExpenseType {
  food, bills, subscriptions, clothing, recreation, other
}

class Expense extends BaseEntity<int> {
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseType type;

  Expense(
      {required int id,
      required this.title,
      required this.amount,
      required this.date,
      ExpenseType type = ExpenseType.other})
      : this.type = type,
        super(id: id);

  Expense.now({
    required int id,
    required String title,
    required double amount,
    ExpenseType type = ExpenseType.other,
  }) : this(
            id: id,
            title: title,
            amount: amount,
            type: type,
            date: DateTime.now());

  Expense copyWith({String? title, double? amount,ExpenseType? type, DateTime? date}) => Expense(
      id: this.id,
      title: title == null ? this.title : title,
      amount: amount == null ? this.amount : amount,
      type: type == null? this.type : type,
      date: date == null ? this.date : date);

  String get typeToString => this.type.toString().split('.').last.capitalize();

  static String expenseTypeToString(ExpenseType type) =>
      type.toString().split('.').last.capitalize();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          amount == other.amount &&
          date == other.date &&
          type == other.type;

  @override
  int get hashCode =>
      title.hashCode ^ amount.hashCode ^ date.hashCode ^ type.hashCode;

  @override
  String toString() {
    return 'Expense{title: $title, amount: $amount, date: $date, type: ${this.typeToString}';
  }
}
