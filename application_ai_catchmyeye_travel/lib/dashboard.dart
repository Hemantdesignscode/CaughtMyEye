import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>?;
          var travelHistory = data?['travelHistory'] ?? [];
          return ListView.builder(
            itemCount: travelHistory.length,
            itemBuilder: (context, index) {
              var search = travelHistory[index];
              return ListTile(
                title: Text(search['location']),
                subtitle: Text('Searched on: ${search['date']}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Future camera page placeholder
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera page coming soon!')));
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}