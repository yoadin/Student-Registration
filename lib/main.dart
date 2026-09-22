import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart';
void main() {
  runApp(const StudentRegistrationApp());
}

class StudentRegistrationApp extends StatelessWidget {
  const StudentRegistrationApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Registration',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: 
        ColorScheme.fromSeed(seedColor: Colors.blue)
      ),
      home: const StudentListScreen(),
    );
  }
}

