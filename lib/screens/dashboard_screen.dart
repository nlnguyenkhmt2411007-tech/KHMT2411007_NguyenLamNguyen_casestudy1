
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_widgets.dart';

class DashboardScreen extends StatelessWidget {
  final List<TransactionModel> items;
  final VoidCallback onViewAll;
  final void Function(TransactionModel) onEdit;

  const DashboardScreen({
    super.key,
    required this.items,
    required this.onViewAll,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final income = items
        .where((e) => e.type == 'income')
        .fold<double>(0, (sum, e) => sum + e.amount);

    final expense = items
        .where((e) => e.type == 'expense')
        .fold<double>(0, (sum, e) => sum + e.amount);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4792FA),
                Color(0xFF2168E3),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SỐ DƯ HIỆN TẠI',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  money(income - expense),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tổng số tiền còn lại',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'TỔNG THU NHẬP',
                value: income,
                color: greenIncome,
                icon: Icons.arrow_downward,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _SummaryCard(
                label: 'TỔNG CHI TIÊU',
                value: expense,
                color: redExpense,
                icon: Icons.arrow_upward,
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Giao dịch gần đây',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Chưa có giao dịch. Nhấn + để bắt đầu.',
              ),
            ),
          ),
        ...items.take(5).map(
              (e) => TransactionTile(
            item: e,
            onTap: () => onEdit(e),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.blueGrey,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              money(value),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
