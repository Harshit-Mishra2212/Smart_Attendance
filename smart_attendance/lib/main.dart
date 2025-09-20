// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/student/student_home.dart';
import 'screens/teacher/teacher_home.dart'; 

import 'screens/admin/admin_page.dart';
import 'theme.dart';

void main() {
  runApp(const SmartAttendApp());
}

class SmartAttendApp extends StatelessWidget {
  const SmartAttendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartAttend',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginPage(),
        '/student': (_) => const StudentHomePage(),
        '/teacher': (_) {
          // For now, passing a placeholder teacher name
          return const TeacherHomePage(teacherName: "Alice");
        },
        '/admin': (_) => const AdminPage(),
      },
    );
  }
}