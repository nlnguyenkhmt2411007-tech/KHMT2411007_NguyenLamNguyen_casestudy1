
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_widgets.dart';
import 'filter_screen.dart';

class TransactionListScreen extends StatefulWidget {
  final List<TransactionModel> items;
  final void Function(TransactionModel) onEdit;
  final void Function(TransactionModel) onDelete;

  const TransactionListScreen({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState
    extends State<TransactionListScreen> {
  String keyword = '';
  TransactionFilter filter = const TransactionFilter();

  @override
  Widget build(BuildContext context) {
    final visible = widget.items.where((item) {
      final text =
          '${item.note} ${item.category} ${money(item.amount)}';

      return filter.matches(item) &&
          text.toLowerCase().contains(
            keyword.toLowerCase().trim(),
          );
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giao dịch',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          keyword = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm giao dịch...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Bộ lọc',
                    icon: const Icon(Icons.tune),
                    onPressed: () async {
                      final result =
                      await Navigator.push<TransactionFilter>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FilterScreen(
                            initial: filter,
                            items: widget.items,
                          ),
                        ),
                      );

                      if (!mounted || result == null) return;

                      setState(() {
                        filter = result;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  _chip('Tất cả', 'all'),
                  _chip('Thu nhập', 'income'),
                  _chip('Chi tiêu', 'expense'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? const Center(
            child: Text('Không tìm thấy giao dịch'),
          )
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16, 0, 16, 90,
            ),
            itemCount: visible.length,
            itemBuilder: (_, index) {
              final item = visible[index];

              return TransactionTile(
                item: item,
                onTap: () => widget.onEdit(item),
                onDelete: () => widget.onDelete(item),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: filter.type == value,
      onSelected: (_) {
        setState(() {
          filter = TransactionFilter(
            type: value,
            category: null,
          );
        });
      },
    );
  }
}
