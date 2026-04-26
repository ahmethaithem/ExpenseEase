import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  double get totalBalance => totalIncome - totalExpenses;

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  ExpenseProvider() {
    _fetchTransactions();
  }

  void _fetchTransactions() {
    _firestore
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      _transactions = snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.id, doc.data());
      }).toList();
      notifyListeners();
    });
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _firestore.collection('transactions').add(transaction.toMap());
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _firestore.collection('transactions').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
    }
  }

  List<TransactionModel> getFilteredTransactions(String filter, DateTime? customDate) {
    if (customDate != null) {
      return _transactions.where((t) {
        return t.date.year == customDate.year &&
               t.date.month == customDate.month &&
               t.date.day == customDate.day;
      }).toList();
    }

    final now = DateTime.now();
    if (filter == 'Last 7 Days') {
      final date = now.subtract(const Duration(days: 7));
      return _transactions.where((t) => t.date.isAfter(date)).toList();
    }
    if (filter == 'Last 30 Days') {
      final date = now.subtract(const Duration(days: 30));
      return _transactions.where((t) => t.date.isAfter(date)).toList();
    }
    if (filter == 'Last 3 Months') {
      final date = DateTime(now.year, now.month - 3, now.day);
      return _transactions.where((t) => t.date.isAfter(date)).toList();
    }
    return _transactions;
  }
}
