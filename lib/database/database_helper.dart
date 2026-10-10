
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance =
  DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'quanlychitieu.db'),
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT NOT NULL
              CHECK(type IN ('income', 'expense')),
            UNIQUE(name, type)
          )
        ''');

        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL CHECK(amount > 0),
            type TEXT NOT NULL
              CHECK(type IN ('income', 'expense')),
            category_id INTEGER NOT NULL,
            note TEXT NOT NULL DEFAULT '',
            date TEXT NOT NULL,
            FOREIGN KEY(category_id)
              REFERENCES categories(id)
          )
        ''');

        await db.execute('''
          CREATE INDEX idx_transactions_date
          ON transactions(date)
        ''');
      },
    );
  }

  Future<int> _getOrCreateCategory(
      DatabaseExecutor executor,
      String category,
      String type,
      ) async {
    final name = category.trim();

    if (name.isEmpty) {
      throw ArgumentError('Danh mục không được để trống');
    }

    final existing = await executor.query(
      'categories',
      columns: ['id'],
      where: 'name = ? AND type = ?',
      whereArgs: [name, type],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      return existing.first['id'] as int;
    }

    await executor.insert(
      'categories',
      {'name': name, 'type': type},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    final rows = await executor.query(
      'categories',
      columns: ['id'],
      where: 'name = ? AND type = ?',
      whereArgs: [name, type],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw StateError('Không tạo được danh mục');
    }

    return rows.first['id'] as int;
  }

  Map<String, Object?> _validatedFields(
      Map<String, dynamic> transaction,
      int categoryId,
      ) {
    final type = transaction['type'] as String;
    final amount =
    (transaction['amount'] as num).toDouble();

    if (type != 'income' && type != 'expense') {
      throw ArgumentError('Loại giao dịch không hợp lệ');
    }

    if (!amount.isFinite || amount <= 0) {
      throw ArgumentError('Số tiền phải lớn hơn 0');
    }

    final rawDate = transaction['date'];
    final parsedDate = rawDate is DateTime
        ? rawDate
        : DateTime.parse(rawDate as String);

    final date = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
    ).toIso8601String();

    return {
      'amount': amount,
      'type': type,
      'category_id': categoryId,
      'note': (transaction['note'] ?? '').toString(),
      'date': date,
    };
  }

  Future<int> insertTransaction(
      Map<String, dynamic> transaction,
      ) async {
    final db = await database;

    return db.transaction((txn) async {
      final type = transaction['type'] as String;
      final category = transaction['category'] as String;

      final categoryId = await _getOrCreateCategory(
        txn,
        category,
        type,
      );

      return txn.insert(
        'transactions',
        _validatedFields(transaction, categoryId),
      );
    });
  }

  Future<List<Map<String, dynamic>>>
  getTransactions() async {
    final db = await database;

    return db.rawQuery('''
      SELECT
        t.id,
        t.amount,
        t.type,
        c.name AS category,
        t.note,
        t.date
      FROM transactions AS t
      INNER JOIN categories AS c
        ON c.id = t.category_id
      ORDER BY t.date DESC, t.id DESC
    ''');
  }

  Future<int> updateTransaction(
      int id,
      Map<String, dynamic> transaction,
      ) async {
    final db = await database;

    return db.transaction((txn) async {
      final type = transaction['type'] as String;
      final category = transaction['category'] as String;

      final categoryId = await _getOrCreateCategory(
        txn,
        category,
        type,
      );

      return txn.update(
        'transactions',
        _validatedFields(transaction, categoryId),
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
