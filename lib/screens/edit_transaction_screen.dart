
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'transaction_form_screen.dart';

class EditTransactionScreen extends StatelessWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return TransactionFormScreen(
      initial: transaction,
    );
  }
}
