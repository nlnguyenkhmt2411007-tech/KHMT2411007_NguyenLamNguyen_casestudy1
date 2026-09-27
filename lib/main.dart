import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseManagerApp());
}

// ============================================================
// MODEL GIAO DỊCH
// ============================================================

class Transaction {
  String type;
  String category;
  double amount;
  DateTime date;
  String note;

  Transaction({
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });
}

// ============================================================
// APP
// ============================================================

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2875EA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFD),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// HOME / DASHBOARD
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Transaction> transactions = [
    Transaction(
      type: 'Chi tiêu',
      category: 'Ăn uống',
      amount: 50000,
      date: DateTime(2026, 9, 3),
      note: 'Ăn sáng',
    ),
    Transaction(
      type: 'Chi tiêu',
      category: 'Di chuyển',
      amount: 100000,
      date: DateTime(2026, 9, 3),
      note: 'Đi học',
    ),
    Transaction(
      type: 'Thu nhập',
      category: 'Lương',
      amount: 8000000,
      date: DateTime(2026, 9, 1),
      note: 'Thu nhập',
    ),
    Transaction(
      type: 'Chi tiêu',
      category: 'Mua sắm',
      amount: 300000,
      date: DateTime(2026, 8, 31),
      note: 'Mua đồ',
    ),
    Transaction(
      type: 'Chi tiêu',
      category: 'Học phí',
      amount: 500000,
      date: DateTime(2026, 8, 30),
      note: 'Học phí',
    ),
    Transaction(
      type: 'Chi tiêu',
      category: 'Giải trí',
      amount: 2050000,
      date: DateTime(2026, 8, 20),
      note: 'Giải trí',
    ),
  ];

  double get totalExpense {
    return transactions
        .where((item) => item.type == 'Chi tiêu')
        .fold(0, (sum, item) => sum + item.amount);
  }

  double get totalIncome {
    return transactions
        .where((item) => item.type == 'Thu nhập')
        .fold(0, (sum, item) => sum + item.amount);
  }

  double get balance {
    return totalIncome - totalExpense;
  }

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
    )} đ';
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // THÊM GIAO DỊCH
  // ============================================================

  Future<void> addTransaction() async {
    final result = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionPage(),
      ),
    );

    if (result != null) {
      setState(() {
        transactions.insert(0, result);
      });
    }
  }

  // ============================================================
  // SỬA GIAO DỊCH
  // ============================================================

  Future<void> editTransaction(int index) async {
    final result = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionPage(
          transaction: transactions[index],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        transactions[index] = result;
      });
    }
  }

  // ============================================================
  // XÓA GIAO DỊCH
  // ============================================================

  void deleteTransaction(int index) {
    setState(() {
      transactions.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa giao dịch'),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color(0xFF18283F),
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Quản lý thu chi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF18283F),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF18283F),
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 7,
                child: Container(
                  width: 17,
                  height: 17,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4D5A),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: IndexedStack(
        index: currentIndex,
        children: [
          buildDashboard(),
          buildTransactionPage(),
          buildStatisticsPage(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addTransaction,
        backgroundColor: const Color(0xFF2875EA),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2875EA),
        unselectedItemColor: const Color(0xFF6F7D91),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget buildDashboard() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
      children: [
        buildBalanceCard(),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: buildSummaryCard(
                title: 'TỔNG THU NHẬP',
                amount: totalIncome,
                icon: Icons.arrow_downward,
                iconColor: const Color(0xFF22A447),
                backgroundColor: const Color(0xFFEAF8EE),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildSummaryCard(
                title: 'TỔNG CHI TIÊU',
                amount: totalExpense,
                icon: Icons.arrow_upward,
                iconColor: const Color(0xFFE83D4B),
                backgroundColor: const Color(0xFFFFEAED),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Giao dịch gần đây',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF25354A),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              child: const Text('Xem tất cả'),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE8ECF2),
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < transactions.length && i < 5; i++)
                buildTransactionTile(
                  transactions[i],
                  i,
                  showActions: false,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2875EA),
            Color(0xFF4B8FF5),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SỐ DƯ HIỆN TẠI',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatMoney(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tổng số tiền còn lại',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF68778C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            formatMoney(amount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRANG GIAO DỊCH
  // ============================================================

  Widget buildTransactionPage() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return buildTransactionTile(
          transactions[index],
          index,
          showActions: true,
        );
      },
    );
  }

  Widget buildTransactionTile(
      Transaction transaction,
      int index, {
        required bool showActions,
      }) {
    final bool isIncome = transaction.type == 'Thu nhập';

    IconData icon;

    switch (transaction.category) {
      case 'Ăn uống':
        icon = Icons.restaurant;
        break;
      case 'Di chuyển':
        icon = Icons.directions_car;
        break;
      case 'Mua sắm':
        icon = Icons.shopping_bag;
        break;
      case 'Giải trí':
        icon = Icons.sports_esports;
        break;
      case 'Học phí':
        icon = Icons.school;
        break;
      case 'Lương':
        icon = Icons.account_balance_wallet;
        break;
      default:
        icon = Icons.attach_money;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isIncome
                  ? const Color(0xFFEAF8EE)
                  : const Color(0xFFFFEAED),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isIncome
                  ? const Color(0xFF22A447)
                  : const Color(0xFFE83D4B),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.note} • ${formatDate(transaction.date)}',
                  style: const TextStyle(
                    color: Color(0xFF7B8798),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}${formatMoney(transaction.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isIncome
                      ? const Color(0xFF22A447)
                      : const Color(0xFFE83D4B),
                  fontSize: 13,
                ),
              ),

              if (showActions)
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.edit,
                        size: 17,
                        color: Color(0xFF2875EA),
                      ),
                      onPressed: () {
                        editTransaction(index);
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.delete,
                        size: 17,
                        color: Color(0xFFE83D4B),
                      ),
                      onPressed: () {
                        deleteTransaction(index);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // THỐNG KÊ
  // ============================================================

  Widget buildStatisticsPage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        const Text(
          'Thống kê chi tiêu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF18283F),
          ),
        ),

        const SizedBox(height: 20),

        buildStatisticItem(
          'Ăn uống',
          50000,
          totalExpense,
          Icons.restaurant,
        ),

        buildStatisticItem(
          'Di chuyển',
          100000,
          totalExpense,
          Icons.directions_car,
        ),

        buildStatisticItem(
          'Mua sắm',
          300000,
          totalExpense,
          Icons.shopping_bag,
        ),

        buildStatisticItem(
          'Học phí',
          500000,
          totalExpense,
          Icons.school,
        ),

        buildStatisticItem(
          'Giải trí',
          2050000,
          totalExpense,
          Icons.sports_esports,
        ),
      ],
    );
  }

  Widget buildStatisticItem(
      String title,
      double amount,
      double total,
      IconData icon,
      ) {
    final double percent = total == 0 ? 0 : amount / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF2875EA),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                formatMoney(amount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: percent,
            minHeight: 7,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: const Color(0xFFE9EDF3),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF2875EA),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MÀN HÌNH THÊM GIAO DỊCH
// ============================================================

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState
    extends State<AddTransactionPage> {
  bool isExpense = true;

  String category = 'Ăn uống';

  DateTime selectedDate = DateTime.now();

  final TextEditingController amountController =
  TextEditingController();

  final TextEditingController noteController =
  TextEditingController();

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void saveTransaction() {
    final double? amount =
    double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ'),
        ),
      );
      return;
    }

    final transaction = Transaction(
      type: isExpense ? 'Chi tiêu' : 'Thu nhập',
      category: category,
      amount: amount,
      date: selectedDate,
      note: noteController.text,
    );

    Navigator.pop(context, transaction);
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Thêm giao dịch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTypeButtons(),

            const SizedBox(height: 22),

            buildLabel('Danh mục'),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: category,
              decoration: inputDecoration(
                icon: Icons.category,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Ăn uống',
                  child: Text('Ăn uống'),
                ),
                DropdownMenuItem(
                  value: 'Di chuyển',
                  child: Text('Di chuyển'),
                ),
                DropdownMenuItem(
                  value: 'Mua sắm',
                  child: Text('Mua sắm'),
                ),
                DropdownMenuItem(
                  value: 'Giải trí',
                  child: Text('Giải trí'),
                ),
                DropdownMenuItem(
                  value: 'Học phí',
                  child: Text('Học phí'),
                ),
                DropdownMenuItem(
                  value: 'Lương',
                  child: Text('Lương'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            buildLabel('Số tiền'),

            const SizedBox(height: 8),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(
                suffixText: 'đ',
              ),
            ),

            const SizedBox(height: 20),

            buildLabel('Ngày giao dịch'),

            const SizedBox(height: 8),

            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: formatDate(selectedDate),
              ),
              onTap: selectDate,
              decoration: inputDecoration(
                suffixIcon: Icons.calendar_month,
              ),
            ),

            const SizedBox(height: 20),

            buildLabel('Ghi chú'),

            const SizedBox(height: 8),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: inputDecoration(),
            ),

            const SizedBox(height: 28),

            buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTypeButtons() {
    return Row(
      children: [
        Expanded(
          child: typeButton(
            title: 'Chi tiêu',
            selected: isExpense,
            onPressed: () {
              setState(() {
                isExpense = true;
              });
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: typeButton(
            title: 'Thu nhập',
            selected: !isExpense,
            onPressed: () {
              setState(() {
                isExpense = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget typeButton({
    required String title,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected
              ? const Color(0xFFFF5C67)
              : Colors.white,
          foregroundColor: selected
              ? Colors.white
              : const Color(0xFF394B63),
          elevation: 0,
          side: BorderSide(
            color: selected
                ? const Color(0xFFFF5C67)
                : const Color(0xFFD9E0E8),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF10233F),
      ),
    );
  }

  InputDecoration inputDecoration({
    String? suffixText,
    IconData? icon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      suffixText: suffixText,
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        color: const Color(0xFF2875EA),
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Icon(
        suffixIcon,
        color: const Color(0xFF65758B),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFD9E0E8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFF2176C7),
          width: 1.5,
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2176C7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: const Text(
          'Lưu',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MÀN HÌNH SỬA GIAO DỊCH
// ============================================================

class EditTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionPage({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionPage> createState() =>
      _EditTransactionPageState();
}

class _EditTransactionPageState
    extends State<EditTransactionPage> {
  late bool isExpense;
  late String category;
  late DateTime selectedDate;

  late TextEditingController amountController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();

    isExpense = widget.transaction.type == 'Chi tiêu';
    category = widget.transaction.category;
    selectedDate = widget.transaction.date;

    amountController = TextEditingController(
      text: widget.transaction.amount.toStringAsFixed(0),
    );

    noteController = TextEditingController(
      text: widget.transaction.note,
    );
  }

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void saveTransaction() {
    final double? amount =
    double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ'),
        ),
      );
      return;
    }

    final updatedTransaction = Transaction(
      type: isExpense ? 'Chi tiêu' : 'Thu nhập',
      category: category,
      amount: amount,
      date: selectedDate,
      note: noteController.text,
    );

    Navigator.pop(context, updatedTransaction);
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sửa giao dịch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTypeButtons(),

            const SizedBox(height: 22),

            buildLabel('Danh mục'),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: category,
              decoration: inputDecoration(
                icon: Icons.category,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Ăn uống',
                  child: Text('Ăn uống'),
                ),
                DropdownMenuItem(
                  value: 'Di chuyển',
                  child: Text('Di chuyển'),
                ),
                DropdownMenuItem(
                  value: 'Mua sắm',
                  child: Text('Mua sắm'),
                ),
                DropdownMenuItem(
                  value: 'Giải trí',
                  child: Text('Giải trí'),
                ),
                DropdownMenuItem(
                  value: 'Học phí',
                  child: Text('Học phí'),
                ),
                DropdownMenuItem(
                  value: 'Lương',
                  child: Text('Lương'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            buildLabel('Số tiền'),

            const SizedBox(height: 8),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(
                suffixText: 'đ',
              ),
            ),

            const SizedBox(height: 20),

            buildLabel('Ngày giao dịch'),

            const SizedBox(height: 8),

            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: formatDate(selectedDate),
              ),
              onTap: selectDate,
              decoration: inputDecoration(
                suffixIcon: Icons.calendar_month,
              ),
            ),

            const SizedBox(height: 20),

            buildLabel('Ghi chú'),

            const SizedBox(height: 8),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: inputDecoration(),
            ),

            const SizedBox(height: 28),

            buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTypeButtons() {
    return Row(
      children: [
        Expanded(
          child: typeButton(
            title: 'Chi tiêu',
            selected: isExpense,
            onPressed: () {
              setState(() {
                isExpense = true;
              });
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: typeButton(
            title: 'Thu nhập',
            selected: !isExpense,
            onPressed: () {
              setState(() {
                isExpense = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget typeButton({
    required String title,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected
              ? const Color(0xFFFF5C67)
              : Colors.white,
          foregroundColor: selected
              ? Colors.white
              : const Color(0xFF394B63),
          elevation: 0,
          side: BorderSide(
            color: selected
                ? const Color(0xFFFF5C67)
                : const Color(0xFFD9E0E8),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF10233F),
      ),
    );
  }

  InputDecoration inputDecoration({
    String? suffixText,
    IconData? icon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      suffixText: suffixText,
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        color: const Color(0xFF2875EA),
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Icon(
        suffixIcon,
        color: const Color(0xFF65758B),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFD9E0E8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFF2176C7),
          width: 1.5,
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2176C7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: const Text(
          'Lưu',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}