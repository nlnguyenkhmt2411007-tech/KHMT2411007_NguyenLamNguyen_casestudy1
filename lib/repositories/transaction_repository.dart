
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<TransactionModel>> getAll() async {
    final rows = await _db.getTransactions();
    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<int> add(TransactionModel item) {
    return _db.insertTransaction(item.toMap());
  }

  Future<int> update(TransactionModel item) {
    if (item.id == null) {
      throw StateError('Thiếu ID giao dịch');
    }

    return _db.updateTransaction(
      item.id!,
      item.toMap(),
    );
  }

  Future<int> delete(int id) {
    return _db.deleteTransaction(id);
  }
}
