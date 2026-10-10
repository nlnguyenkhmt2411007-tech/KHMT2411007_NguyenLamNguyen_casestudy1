
import 'package:flutter/material.dart';
import '../widgets/transaction_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Cá nhân',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        const Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE4EDFF),
                  child: Icon(
                    Icons.person,
                    color: primaryBlue,
                    size: 32,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Người dùng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Dữ liệu được lưu trên thiết bị',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Card(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.storage_outlined),
                title: Text('Dữ liệu SQLite'),
                subtitle: Text('quanlychitieu.db'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Lưu trữ cục bộ'),
                subtitle: Text(
                  'Chưa có tài khoản đăng nhập '
                      '/ đồng bộ đám mây',
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Expense Manager'),
                subtitle: Text(
                  'Bài thực hành Flutter - Buổi 6',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
