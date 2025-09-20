// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:smart_attendance/screens/admin/admin_page.dart';
import 'package:smart_attendance/screens/student/student_home.dart';
import 'package:smart_attendance/screens/teacher/teacher_home.dart';
import '../widgets/role_card.dart';
import '../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedRole;

  // Student controllers
  final TextEditingController studentRollController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController studentBranchController = TextEditingController();
  final TextEditingController studentSectionController = TextEditingController();
  final TextEditingController studentDeptController = TextEditingController();

  // Teacher controllers
  final TextEditingController teacherNameController = TextEditingController();
  final TextEditingController teacherDeptController = TextEditingController();
  final TextEditingController teacherIdController = TextEditingController();

  // Admin controllers
  final TextEditingController adminNameController = TextEditingController();
  final TextEditingController adminDeptController = TextEditingController();
  final TextEditingController adminIdController = TextEditingController();

  @override
  void dispose() {
    studentRollController.dispose();
    studentNameController.dispose();
    studentBranchController.dispose();
    studentSectionController.dispose();
    studentDeptController.dispose();
    teacherNameController.dispose();
    teacherDeptController.dispose();
    teacherIdController.dispose();
    adminNameController.dispose();
    adminDeptController.dispose();
    adminIdController.dispose();
    super.dispose();
  }

  void handleLogin() {
    bool valid = false;

    if (selectedRole == 'Student') {
      valid = studentRollController.text.isNotEmpty &&
          studentNameController.text.isNotEmpty &&
          studentBranchController.text.isNotEmpty &&
          studentSectionController.text.isNotEmpty &&
          studentDeptController.text.isNotEmpty;

      if (valid) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHomePage(),
          ),
        );
      }
      
    } else if (selectedRole == 'Teacher') {
      valid = teacherNameController.text.isNotEmpty &&
          teacherDeptController.text.isNotEmpty &&
          teacherIdController.text.isNotEmpty;

      if (valid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TeacherHomePage(
        teacherName: teacherNameController.text,
      ),
    ),
  );
}

    } else if (selectedRole == 'Administrator') {
      valid = adminNameController.text.isNotEmpty &&
          adminDeptController.text.isNotEmpty &&
          adminIdController.text.isNotEmpty;

      if (valid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AdminPage(),
    ),
  );
}

    }

    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  Widget _roleSelectionCard(String title, IconData icon, Color color) {
    return RoleCard(
      title: title,
      subtitle: 'Continue as $title',
      icon: icon,
      cardColor: color,
      onTap: () => setState(() => selectedRole = title),
    );
  }

  Widget roleSelectionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Login as',
          style:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 14),
        _roleSelectionCard('Student', Icons.school, const Color(0xFFEFF6FF)),
        const SizedBox(height: 10),
        _roleSelectionCard(
            'Teacher', Icons.person_search, const Color(0xFFF5F3FF)),
        const SizedBox(height: 10),
        _roleSelectionCard(
            'Administrator', Icons.admin_panel_settings, const Color(0xFFF0FDF4)),
      ],
    );
  }

  Widget studentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Student Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        TextField(
          controller: studentRollController,
          decoration: const InputDecoration(labelText: 'Roll Number'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: studentNameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: studentBranchController,
          decoration: const InputDecoration(labelText: 'Branch'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: studentSectionController,
          decoration: const InputDecoration(labelText: 'Section'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: studentDeptController,
          decoration: const InputDecoration(labelText: 'Department'),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: handleLogin,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Login'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => selectedRole = null),
          child: const Text('Back to role selection'),
        ),
      ],
    );
  }

  Widget teacherForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Teacher Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        TextField(
          controller: teacherNameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: teacherDeptController,
          decoration: const InputDecoration(labelText: 'Department'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: teacherIdController,
          decoration: const InputDecoration(labelText: 'Employee ID'),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: handleLogin,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Login'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => selectedRole = null),
          child: const Text('Back to role selection'),
        ),
      ],
    );
  }

  Widget adminForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Administrator Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        TextField(
          controller: adminNameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: adminDeptController,
          decoration: const InputDecoration(labelText: 'Department'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: adminIdController,
          decoration: const InputDecoration(labelText: 'Admin ID'),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: handleLogin,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Login'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => selectedRole = null),
          child: const Text('Back to role selection'),
        ),
      ],
    );
  }

  Widget roleForm() {
    if (selectedRole == 'Student') return studentForm();
    if (selectedRole == 'Teacher') return teacherForm();
    if (selectedRole == 'Administrator') return adminForm();
    return roleSelectionSection(context);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 20);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'SmartAttend',
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 18),

              // Card with role selection or form
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: roleForm(),
                ),
              ),

              const SizedBox(height: 12),
              Text('Version 0.1 • Demo', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
