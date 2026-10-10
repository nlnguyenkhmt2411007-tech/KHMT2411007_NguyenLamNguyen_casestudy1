
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_widgets.dart';

class TransactionFormScreen extends StatefulWidget {
  final TransactionModel? initial;

  const TransactionFormScreen({
    super.key,
    this.initial,
  });

  @override
  State<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState
    extends State<TransactionFormScreen> {
  late String type;
  late String category;
  late DateTime date;
  late TextEditingController amount;
  late TextEditingController note;

  final expenses = [
    'Ăn uống',
    'Mua sắm',
    'Di chuyển',
    'Giải trí',
    'Hóa đơn',
    'Sức khỏe',
    'Giáo dục',
    'Học phí',
    'Khác',
  ];

  final incomes = [
    'Thu nhập',
    'Lương',
    'Thưởng',
    'Tiền làm thêm',
    'Đầu tư',
    'Khác',
  ];

  List<String> get categories =>
      type == 'expense' ? expenses : incomes;

  @override
  void initState() {
    super.initState();

    type = widget.initial?.type ?? 'expense';
    category = widget.initial?.category ?? expenses.first;
    date = widget.initial?.date ?? DateTime.now();

    if (!categories.contains(category)) {
      categories.add(category);
    }

    amount = TextEditingController(
      text: widget.initial?.amount.toStringAsFixed(0) ?? '',
    );

    note = TextEditingController(
      text: widget.initial?.note ?? '',
    );
  }

  @override
  void dispose() {
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  void changeType(String value) {
    setState(() {
      type = value;

      if (!categories.contains(category)) {
        category = categories.first;
      }
    });
  }

  Future<void> pickDate() async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (!mounted) return;

    if (chosen != null) {
      setState(() {
        date = chosen;
      });
    }
  }

  void save() {
    final raw = amount.text.replaceAll(
      RegExp(r'[.,\s]'),
      '',
    );

    final value = double.tryParse(raw);

    if (value == null ||
        !value.isFinite ||
        value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập số tiền hợp lệ lớn hơn 0',
          ),
        ),
      );
      return;
    }

    final result = TransactionModel(
      id: widget.initial?.id,
      type: type,
      category: category,
      amount: value,
      date: date,
      note: note.text.trim(),
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initial != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          editing ? 'Sửa giao dịch' : 'Thêm giao dịch',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _typeButton(
                    'Chi tiêu',
                    'expense',
                    redExpense,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _typeButton(
                    'Thu nhập',
                    'income',
                    primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Danh mục',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey(type),
              initialValue: category,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: categories.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(
                        categoryIcon(item),
                        size: 17,
                        color: type == 'income'
                            ? greenIncome
                            : redExpense,
                      ),
                      const SizedBox(width: 10),
                      Text(item),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            const SizedBox(height: 18),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9., ]'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Số tiền',
                suffixText: 'đ',
                hintText: 'Nhập số tiền',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Ngày giao dịch',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(dateLabel(date)),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: note,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Ghi chú (tùy chọn)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: save,
                style: FilledButton.styleFrom(
                  backgroundColor: primaryBlue,
                ),
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeButton(
      String label,
      String value,
      Color color,
      ) {
    final selected = type == value;

    return SizedBox(
      height: 46,
      child: FilledButton(
        onPressed: () => changeType(value),
        style: FilledButton.styleFrom(
          backgroundColor:
          selected ? color : Colors.white,
          foregroundColor:
          selected ? Colors.white : Colors.black54,
          side: BorderSide(
            color: selected
                ? color
                : const Color(0xFFD7DDE5),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
