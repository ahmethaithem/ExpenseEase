import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = '';
  String _currencySymbol = '\$';

  String get userName => _userName;
  String get currencySymbol => _currencySymbol;

  UserProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToUserData(user.uid);
      } else {
        _userName = '';
        _currencySymbol = '\$';
        notifyListeners();
      }
    });
  }

  void _listenToUserData(String uid) {
    _firestore.collection('users').doc(uid).snapshots().listen((doc) {
      if (doc.exists) {
        _userName = doc.data()?['name'] ?? '';
        _currencySymbol = doc.data()?['currency'] ?? '\$';
        notifyListeners();
      }
    });
  }

  Future<void> updateCurrency(String newCurrency) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'currency': newCurrency,
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
