
import 'package:flutter_test/flutter_test.dart';
import 'package:app_test/models/transaction_model.dart';

void main() {
  test('Kiểm tra model giao dịch', () {
    final transaction = TransactionModel(
      type: 'expense',
      category: 'Ăn uống',
      amount: 50000,
      date: DateTime(2026, 10, 10),
      note: 'Ăn sáng',
    );

    expect(transaction.type, 'expense');
    expect(transaction.category, 'Ăn uống');
    expect(transaction.amount, 50000);
    expect(transaction.note, 'Ăn sáng');
  });
}
