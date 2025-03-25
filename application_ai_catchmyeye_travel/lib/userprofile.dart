import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  bool _isFirstTime = false;

  @override
  void initState() {
    super.initState();
    _checkProfileStatus();
  }

  Future<void> _checkProfileStatus() async {
    var doc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    if (!doc.exists || !(doc.data()?['profileCompleted'] ?? false)) {
      setState(() => _isFirstTime = true);
    } else {
      _nameController.text = doc.data()?['name'] ?? '';
    }
  }

  Future<void> _saveProfile() async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'email': _auth.currentUser!.email,
      'name': _nameController.text,
      'profileCompleted': true,
      'travelHistory': [],
    }, SetOptions(merge: true));
    if (_isFirstTime) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text(_isFirstTime ? 'Save & Continue' : 'Update Profile'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}