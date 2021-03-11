import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String get userid {
    return _auth.currentUser.uid;
  }

  bool get isloggedin {
    if (_auth.currentUser == null) {
      return false;
    }
    return true;
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    notifyListeners();
  }

  Future<void> signup(
      String email, String password, String name, String role) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser.uid)
        .set(
          role == 'Patient'
              ? {
                  'name': name,
                  'email': email,
                  'role': role,
                  'patientid': _auth.currentUser.uid,
                  'appointments': [],
                  'medicalhistory': [],
                }
              : {
                  'name': name,
                  'email': email,
                  'role': role,
                  'doctorid': _auth.currentUser.uid,
                  'appointments': [],
                },
        );
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
