
import 'package:flutter/material.dart';
import '../widgets/transaction_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onStart;

  const WelcomeScreen({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: primaryBlue,
                  size: 64,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF162B4D),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Quản lý chi tiêu cá nhân\n'
                    'đơn giản và hiệu quả',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryBlue,
                  ),
                  child: const Text('Bắt đầu'),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
