import 'package:flutter/material.dart';

void main() {
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
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Icon chiếc ví
            _buildWallet(),

            const SizedBox(height: 24),

            // Tiêu đề
            const Text(
              'Expense Manager',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10233F),
              ),
            ),

            const SizedBox(height: 14),

            // Mô tả
            const Text(
              'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF8491A5),
              ),
            ),

            const Spacer(flex: 4),

            // Nút Bắt đầu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Sau này sẽ mở màn hình chính
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2176C7),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Tạo icon chiếc ví bằng các Container
  static Widget _buildWallet() {
    return SizedBox(
      width: 120,
      height: 105,
      child: Stack(
        children: [
          // Tờ tiền màu xanh lá phía sau
          Positioned(
            left: 40,
            top: 0,
            child: Container(
              width: 70,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF76C77F),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          // Tờ tiền màu xanh lá thứ hai
          Positioned(
            left: 30,
            top: 12,
            child: Container(
              width: 75,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF54B867),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          // Thân ví
          Positioned(
            left: 12,
            top: 28,
            child: Container(
              width: 105,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF2176C7),
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),

          // Phần khóa ví
          Positioned(
            right: 0,
            top: 48,
            child: Container(
              width: 47,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF1558A6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(9),
                  bottomLeft: Radius.circular(9),
                ),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}