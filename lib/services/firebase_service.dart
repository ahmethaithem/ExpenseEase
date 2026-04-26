import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Auth First: Call createUserWithEmailAndPassword
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // 2. Wait for UID
        final String uid = user.uid;

        // 3. Firestore Second: Use that uid to create a document with .set()
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': name,
          'email': email,
          'currency': '\$',
        });

        return user;
      }
      return null;
    } catch (e) {
      // 4. Error Logging
      print('Signup Error: \$e');
      rethrow; // Rethrow to let the UI show the snackbar
    }
  }
}
