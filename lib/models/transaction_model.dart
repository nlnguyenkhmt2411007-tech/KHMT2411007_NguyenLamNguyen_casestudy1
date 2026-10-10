
class TransactionModel {
  final int? id;
  final String type;
  final String category;
  final double amount;
  final DateTime date;
  final String note;

  const TransactionModel({
    this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });

  factory TransactionModel.fromMap(
      Map<String, dynamic> row) {
    return TransactionModel(
      id: row['id'] as int,
      type: row['type'] as String,
      category: row['category'] as String,
      amount: (row['amount'] as num).toDouble(),
      date: DateTime.parse(row['date'] as String),
      note: (row['note'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
}
