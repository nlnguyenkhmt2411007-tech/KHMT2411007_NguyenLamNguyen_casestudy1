
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

const primaryBlue = Color(0xFF2875EA);
const redExpense = Color(0xFFF25564);
const greenIncome = Color(0xFF24AA62);

String money(double value) {
  final digits = value.toStringAsFixed(0);
  final formatted = digits.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
  );

  return '$formatted đ';
}

String dateLabel(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Ăn uống':
      return Icons.restaurant;
    case 'Di chuyển':
      return Icons.directions_car;
    case 'Mua sắm':
      return Icons.shopping_cart;
    case 'Lương':
    case 'Thu nhập':
      return Icons.payments;
    case 'Giải trí':
      return Icons.sports_esports;
    case 'Học phí':
    case 'Giáo dục':
      return Icons.school;
    case 'Hóa đơn':
      return Icons.receipt_long;
    case 'Sức khỏe':
      return Icons.favorite;
    default:
      return Icons.category;
  }
}

class TransactionTile extends StatelessWidget {
  final TransactionModel item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final income = item.type == 'income';
    final color = income ? greenIncome : redExpense;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFFE9EDF3),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            categoryIcon(item.category),
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          item.note.isEmpty ? item.category : item.note,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          '${item.category} • ${dateLabel(item.date)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${income ? '+' : '-'}${money(item.amount)}',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onDelete != null)
              IconButton(
                tooltip: 'Xóa',
                icon: const Icon(
                  Icons.delete_outline,
                  size: 19,
                ),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
