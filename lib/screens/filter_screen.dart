
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_widgets.dart';

class TransactionFilter {
  final String type;
  final String? category;

  const TransactionFilter({
    this.type = 'all',
    this.category,
  });

  bool matches(TransactionModel item) {
    return (type == 'all' || item.type == type) &&
        (category == null || item.category == category);
  }
}

class FilterScreen extends StatefulWidget {
  final TransactionFilter initial;
  final List<TransactionModel> items;

  const FilterScreen({
    super.key,
    required this.initial,
    required this.items,
  });

  @override
  State<FilterScreen> createState() =>
      _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String type;
  late String? category;

  @override
  void initState() {
    super.initState();
    type = widget.initial.type;
    category = widget.initial.category;
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.items
        .where((item) {
      return type == 'all' || item.type == type;
    })
        .map((item) => item.category)
        .toSet()
        .toList()
      ..sort();

    if (category != null &&
        !categories.contains(category)) {
      category = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ lọc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loại giao dịch',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            for (final entry in const [
              ('all', 'Tất cả'),
              ('income', 'Thu nhập'),
              ('expense', 'Chi tiêu'),
            ])
              ListTile(
                onTap: () {
                  setState(() {
                    type = entry.$1;
                    category = null;
                  });
                },
                leading: Icon(
                  type == entry.$1
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: primaryBlue,
                ),
                title: Text(entry.$2),
              ),
            const SizedBox(height: 10),
            const Text(
              'Danh mục',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButtonFormField<String>(
              key: ValueKey(type),
              initialValue: category,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              hint: const Text('Tất cả danh mục'),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('Tất cả danh mục'),
                ),
                ...categories.map(
                      (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  category = value == '' ? null : value;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: primaryBlue,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    TransactionFilter(
                      type: type,
                      category: category,
                    ),
                  );
                },
                child: const Text('Áp dụng bộ lọc'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
