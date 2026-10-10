
import 'package:flutter/material.dart';

import 'models/transaction_model.dart';
import 'repositories/transaction_repository.dart';

import 'screens/welcome_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/edit_transaction_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/profile_screen.dart';

import 'widgets/transaction_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExpenseManagerApp());
}

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F9FC),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final repo = TransactionRepository();

  List<TransactionModel> items = [];

  bool started = false;
  bool loading = false;
  int tab = 0;

  Future<void> refresh() async {
    setState(() {
      loading = true;
    });

    try {
      final result = await repo.getAll();

      if (!mounted) return;

      setState(() {
        items = result;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      showError(error);
    }
  }

  void showError(Object error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi: $error'),
      ),
    );
  }

  Future<void> add() async {
    final item = await Navigator.push<TransactionModel>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTransactionScreen(),
      ),
    );

    if (!mounted || item == null) return;

    try {
      await repo.add(item);
      await refresh();
    } catch (error) {
      showError(error);
    }
  }

  Future<void> edit(TransactionModel original) async {
    final updated =
    await Navigator.push<TransactionModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditTransactionScreen(
          transaction: original,
        ),
      ),
    );

    if (!mounted || updated == null) return;

    try {
      await repo.update(updated);
      await refresh();
    } catch (error) {
      showError(error);
    }
  }

  Future<void> delete(TransactionModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa giao dịch?'),
          content: const Text(
            'Giao dịch sẽ bị xóa khỏi SQLite.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (!mounted ||
        confirmed != true ||
        item.id == null) {
      return;
    }

    try {
      await repo.delete(item.id!);
      await refresh();
    } catch (error) {
      showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!started) {
      return WelcomeScreen(
        onStart: () {
          setState(() {
            started = true;
          });

          refresh();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tab == 0
              ? 'Quản lý thu chi'
              : tab == 1
              ? 'Giao dịch'
              : tab == 2
              ? 'Thống kê'
              : 'Cá nhân',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Làm mới',
            onPressed: refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : IndexedStack(
        index: tab,
        children: [
          DashboardScreen(
            items: items,
            onViewAll: () {
              setState(() {
                tab = 1;
              });
            },
            onEdit: edit,
          ),
          TransactionListScreen(
            items: items,
            onEdit: edit,
            onDelete: delete,
          ),
          StatisticsScreen(items: items),
          const ProfileScreen(),
        ],
      ),
      floatingActionButton: tab <= 1
          ? FloatingActionButton(
        onPressed: add,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (value) {
          setState(() {
            tab = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.donut_large_outlined),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }
}
