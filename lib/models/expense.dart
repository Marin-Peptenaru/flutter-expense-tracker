import '../models/base_entity.dart';

class Expense extends BaseEntity<int>{
  final String title;
  final double amount;
  final DateTime date;

  Expense(
      {required int id,
      required this.title,
      required this.amount,
      required this.date}): super(id: id);

  Expense.now({
    required int id,
    required String title,
    required double amount,
  }): this(id: id, title: title, amount: amount, date: DateTime.now());

  Expense copyWith({String? title, double? amount, DateTime? date})
    => Expense
      (id: this.id,
      title: title == null? this.title : title,
      amount: amount == null? this.amount : amount,
      date: date == null? this.date : date);

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
