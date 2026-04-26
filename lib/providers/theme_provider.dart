import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToThemeData(user.uid);
      } else {
        _themeMode = ThemeMode.system;
        notifyListeners();
      }
    });
  }

  void _listenToThemeData(String uid) {
    _firestore.collection('users').doc(uid).snapshots().listen((doc) {
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('isDarkMode')) {
          final isDark = data['isDarkMode'] as bool;
          _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
          notifyListeners();
        }
      }
    });
  }

  Future<void> toggleTheme() async {
    final user = _auth.currentUser;
    final newIsDark = _themeMode == ThemeMode.light;
    
    // Update local state instantly for better UX
    _themeMode = newIsDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // Persist to Firestore
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'isDarkMode': newIsDark,
      }, SetOptions(merge: true));
    }
  }
}
