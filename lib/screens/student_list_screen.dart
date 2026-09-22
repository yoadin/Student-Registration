import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
const StudentListScreen({super.key});
@override
State<StudentListScreen> createState()=> _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar(
      title: const Text('Student Registration'),
      backgroundColor: Colors.blue,
    ),
    body: const Center(
      child: Text('No Student Registered yet.'),
    ), 
    );
  }
  }

