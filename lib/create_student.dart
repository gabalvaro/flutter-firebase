import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({super.key});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  Future<void> saveTestData() async {
    await FirebaseFirestore.instance.collection('students').add({
      'name': 'Juan Dela Cruz',
      'course': 'BS Computer Science',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Page")),
      body: Column(
        children: [
          FilledButton(
            onPressed: saveTestData,
            child: const Text('Save Test Student'),
          ),
        ],
      ),
    );
  }
}
