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
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2176C7),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// MÀN HÌNH DANH SÁCH
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> transactions = [];

  double get totalExpense {
    double total = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'Chi tiêu') {
        total += transaction.amount;
      }
    }

    return total;
  }

  Future<void> addTransaction() async {
    final Transaction? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionPage(),
      ),
    );

    if (result != null) {
      setState(() {
        transactions.add(result);
      });
    }
  }

  Future<void> editTransaction(int index) async {
    final Transaction? result = await Navigator.push(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF10233F),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tổng chi tiêu
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FC),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng chi tiêu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8491A5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatMoney(totalExpense),
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2176C7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Danh sách khoản chi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10233F),
                ),
              ),

              const SizedBox(height: 15),

              // Danh sách
              Expanded(
                child: transactions.isEmpty
                    ? const Center(
                  child: Text(
                    'Chưa có khoản chi nào',
                    style: TextStyle(
                      color: Color(0xFF9AA5B5),
                      fontSize: 15,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];

                    return _buildTransactionItem(
                      transaction,
                      index,
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Nút thêm
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: addTransaction,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Thêm khoản chi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2176C7),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      Transaction transaction,
      int index,
      ) {
    final bool isExpense = transaction.type == 'Chi tiêu';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE1E6ED),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isExpense
                  ? const Color(0xFFFFE8EA)
                  : const Color(0xFFE7F7EA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction.category == 'Ăn uống'
                  ? Icons.restaurant
                  : Icons.category,
              color: isExpense
                  ? const Color(0xFFFF5C67)
                  : const Color(0xFF54B867),
            ),
          ),

          const SizedBox(width: 12),

          // Thông tin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.note.isEmpty
                      ? 'Không có ghi chú'
                      : transaction.note,
                  style: const TextStyle(
                    color: Color(0xFF69788C),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  formatDate(transaction.date),
                  style: const TextStyle(
                    color: Color(0xFF69788C),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Số tiền + nút
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isExpense ? '-' : '+'}${formatMoney(transaction.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isExpense
                      ? const Color(0xFFFF5C67)
                      : const Color(0xFF54B867),
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      editTransaction(index);
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                    ),
                    color: const Color(0xFF2176C7),
                    tooltip: 'Sửa',
                  ),
                  IconButton(
                    onPressed: () {
                      deleteTransaction(index);
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 18,
                    ),
                    color: const Color(0xFFFF5C67),
                    tooltip: 'Xóa',
                  ),
                ],
              ),
            ],
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
    final DateTime? pickedDate = await showDatePicker(
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

    final Transaction transaction = Transaction(
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
      appBar: AppBar(
        title: const Text(
          'Thêm giao dịch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF10233F),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF10233F),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionType(),

            const SizedBox(height: 22),

            _buildLabel('Danh mục'),

            const SizedBox(height: 8),

            _buildCategoryDropdown(),

            const SizedBox(height: 20),

            _buildLabel('Số tiền'),

            const SizedBox(height: 8),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                hintText: 'Nhập số tiền',
                suffixText: 'đ',
              ),
            ),

            const SizedBox(height: 20),

            _buildLabel('Ngày giao dịch'),

            const SizedBox(height: 8),

            _buildDateField(),

            const SizedBox(height: 20),

            _buildLabel('Ghi chú'),

            const SizedBox(height: 8),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: _inputDecoration(
                hintText: 'Nhập ghi chú (tùy chọn)',
              ),
            ),

            const SizedBox(height: 28),

            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionType() {
    return Row(
      children: [
        Expanded(
          child: _typeButton(
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
          child: _typeButton(
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

  Widget _typeButton({
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

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: category,
      decoration: _inputDecoration(
        icon: Icons.restaurant,
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
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            category = value;
          });
        }
      },
    );
  }

  Widget _buildDateField() {
    return TextField(
      readOnly: true,
      controller: TextEditingController(
        text: formatDate(selectedDate),
      ),
      onTap: selectDate,
      decoration: _inputDecoration(
        suffixIcon: Icons.calendar_month,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF10233F),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    String? suffixText,
    IconData? icon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixText: suffixText,
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        color: const Color(0xFFFF6871),
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Icon(
        suffixIcon,
        color: const Color(0xFF65758B),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFD9E0E8),
        ),
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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2176C7),
          foregroundColor: Colors.white,
          elevation: 0,
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
    final DateTime? pickedDate = await showDatePicker(
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

    final Transaction updatedTransaction = Transaction(
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
      appBar: AppBar(
        title: const Text(
          'Sửa giao dịch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF10233F),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF10233F),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionType(),

            const SizedBox(height: 22),

            _buildLabel('Danh mục'),

            const SizedBox(height: 8),

            _buildCategoryDropdown(),

            const SizedBox(height: 20),

            _buildLabel('Số tiền'),

            const SizedBox(height: 8),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                suffixText: 'đ',
              ),
            ),

            const SizedBox(height: 20),

            _buildLabel('Ngày giao dịch'),

            const SizedBox(height: 8),

            _buildDateField(),

            const SizedBox(height: 20),

            _buildLabel('Ghi chú'),

            const SizedBox(height: 8),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: _inputDecoration(),
            ),

            const SizedBox(height: 28),

            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionType() {
    return Row(
      children: [
        Expanded(
          child: _typeButton(
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
          child: _typeButton(
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

  Widget _typeButton({
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

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: category,
      decoration: _inputDecoration(
        icon: Icons.restaurant,
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
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            category = value;
          });
        }
      },
    );
  }

  Widget _buildDateField() {
    return TextField(
      readOnly: true,
      controller: TextEditingController(
        text: formatDate(selectedDate),
      ),
      onTap: selectDate,
      decoration: _inputDecoration(
        suffixIcon: Icons.calendar_month,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF10233F),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    String? suffixText,
    IconData? icon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixText: suffixText,
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        color: const Color(0xFFFF6871),
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Icon(
        suffixIcon,
        color: const Color(0xFF65758B),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFD9E0E8),
        ),
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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2176C7),
          foregroundColor: Colors.white,
          elevation: 0,
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