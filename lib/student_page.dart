import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/create_student.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final CollectionReference<Map<String, dynamic>> students = FirebaseFirestore
      .instance
      .collection('students');

  String getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (name.trim().isEmpty) return '?';

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2196F3);
    const backgroundColor = Color(0xFFF5F7FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Student Page",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateStudent()),
                );
              },
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 25),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: students.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: const CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final documents = snapshot.data?.docs ?? [];

                  if (documents.isEmpty) {
                    return Center(
                      child: Text(
                        'No student records yet.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      final data = document.data();

                      final studentno = data["student_no"] ?? '';
                      final name = data["name"] ?? '';
                      final course = data['course'] ?? '';

                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 14),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(18),
                          side: BorderSide(color: Color(0xFFE5EAF2), width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: const Color(0xFFE3F0FF),
                                    child: Text(
                                      getInitials(name),
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),

                                        const SizedBox(height: 7),

                                        Row(
                                          children: [
                                            Icon(
                                              Icons.badge_outlined,
                                              size: 16,
                                              color: Color(0xFF94A388),
                                            ),
                                            SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                studentno,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF647488),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color(0xFF94A3B8),
                                      size: 23,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F6FD),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.school_outlined,
                                      size: 17,
                                      color: primaryColor,
                                    ),

                                    const SizedBox(width: 7),

                                    Flexible(
                                      child: Text(
                                        course,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
