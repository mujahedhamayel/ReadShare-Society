import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalScerrn extends StatelessWidget {
  const PersonalScerrn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('personal screen'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary)),
        ],
      ),
      body: const Center(
        child: Text('Logged In'),
      ),
    );
  }
}
