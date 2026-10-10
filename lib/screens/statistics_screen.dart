
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_widgets.dart';

class StatisticsScreen extends StatefulWidget {
  final List<TransactionModel> items;

  const StatisticsScreen({
    super.key,
    required this.items,
  });

  @override
  State<StatisticsScreen> createState() =>
      _StatisticsScreenState();
}

class _StatisticsScreenState
    extends State<StatisticsScreen> {
  int period = 0;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(
      Duration(days: now.weekday - 1),
    );

    final expenses = widget.items.where((item) {
      if (item.type != 'expense') return false;

      if (period == 0) {
        return item.date.year == now.year &&
            item.date.month == now.month;
      }

      if (period == 1) {
        final end = monday.add(const Duration(days: 7));

        return !item.date.isBefore(monday) &&
            item.date.isBefore(end);
      }

      return item.date.year == now.year;
    }).toList();

    final totals = <String, double>{};

    for (final item in expenses) {
      totals[item.category] =
          (totals[item.category] ?? 0) + item.amount;
    }

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sum = entries.fold<double>(
      0,
          (value, entry) => value + entry.value,
    );

    const colors = [
      Color(0xFFF25564),
      Color(0xFF3F91ED),
      Color(0xFF4EBE8A),
      Color(0xFF9D70E8),
      Color(0xFFF3AC64),
      Color(0xFF5CC9C9),
      Color(0xFFDA75B0),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        const Text(
          'Thống kê',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          children: [
            ChoiceChip(
              label: const Text('Tháng này'),
              selected: period == 0,
              onSelected: (_) {
                setState(() => period = 0);
              },
            ),
            ChoiceChip(
              label: const Text('Tuần này'),
              selected: period == 1,
              onSelected: (_) {
                setState(() => period = 1);
              },
            ),
            ChoiceChip(
              label: const Text('Năm nay'),
              selected: period == 2,
              onSelected: (_) {
                setState(() => period = 2);
              },
            ),
          ],
        ),
        const SizedBox(height: 23),
        SizedBox(
          height: 235,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(215, 215),
                  painter: _DonutPainter(
                    values: entries
                        .map((entry) => entry.value)
                        .toList(),
                    colors: colors,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tổng chi tiêu',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 11,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        money(sum),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 13),
        if (entries.isEmpty)
          const Center(
            child: Text('Chưa có khoản chi trong kỳ'),
          ),
        for (var i = 0; i < entries.length; i++)
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        categoryIcon(entries[i].key),
                        color: colors[i % colors.length],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(entries[i].key),
                      ),
                      Text(
                        money(entries[i].value),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: sum == 0
                        ? 0
                        : entries[i].value / sum,
                    minHeight: 6,
                    color: colors[i % colors.length],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  const _DonutPainter({
    required this.values,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      12,
      12,
      size.width - 24,
      size.height - 24,
    );

    final total = values.fold<double>(
      0,
          (a, b) => a + b,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 29;

    if (total == 0) {
      paint.color = const Color(0xFFE7ECF3);

      canvas.drawArc(
        rect,
        0,
        2 * math.pi,
        false,
        paint,
      );
      return;
    }

    var start = -math.pi / 2;

    for (var i = 0; i < values.length; i++) {
      final angle = values[i] / total * 2 * math.pi;
      paint.color = colors[i % colors.length];

      canvas.drawArc(
        rect,
        start,
        angle,
        false,
        paint,
      );

      start += angle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) {
    return true;
  }
}
