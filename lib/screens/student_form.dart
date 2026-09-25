import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_registration/models/student.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  @override
  void initState() {
    super.initState();
    getStudents();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final List<Student> students = [];
  int? editingIndex;

  @override
  void dispose() {
    nameController.dispose();
    departmentController.dispose();
    idController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> registerStudent() async {
    if (nameController.text.trim().isEmpty ||
        idController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        departmentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fields can't be empty!")));
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.192/student_api/register_student.php'),
        headers: {'Content-Type': 'application/json'},
        body:
            '''
        {
          "id": "${idController.text}",
          "name": "${nameController.text}",
          "age": ${ageController.text},
          "department": "${departmentController.text}"
        }
      ''',
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        final newStudent = Student(
          id: idController.text,
          name: nameController.text,
          age: ageController.text,
          department: departmentController.text,
        );

        setState(() {
          students.add(newStudent);
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data["message"])));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data["message"])));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> getStudents() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.192/student_api/get_students.php'),
      );

      final data = jsonDecode(response.body);

      students.clear();

      for (var student in data) {
        students.add(Student.fromJson(student));
      }

      setState(() {});
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.0.192/student_api/delete_student.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id": id}),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() {
          students.removeWhere((student) => student.id == id);
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data["message"])));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data["message"])));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateStudent(String id) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.0.192/student_api/update_student.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": id,
          "name": nameController.text,
          "age": int.parse(ageController.text),
          "department": departmentController.text,
        }),
      );

      final data = jsonDecode(response.body);

      print(data["success"]);
      print(data["message"]);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.school),
        title: const Text("Student Registration Form"),
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(5.0),

              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Student Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 5),

                  TextField(
                    controller: departmentController,
                    decoration: const InputDecoration(
                      labelText: "Department",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 5),

                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: "Student ID",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 5),

                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          registerStudent();
                          // idController.clear();
                          // nameController.clear();
                          // ageController.clear();
                          // departmentController.clear();
                        },

                        child: const Icon(Icons.app_registration),
                      ),
                      if (editingIndex != null)
                        if (editingIndex != null)
                          ElevatedButton(
                            onPressed: () {
                              updateStudent(students[editingIndex!].id);
                              getStudents();
                            },
                            child: const Icon(Icons.save),
                          ),
                      ElevatedButton(
                        onPressed: () {
                          idController.clear();
                          nameController.clear();
                          ageController.clear();
                          departmentController.clear();
                        },
                        child: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  const Text(
                    "Registered Student: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  for (int index = 0; index < students.length; index++)
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.blue.shade400,
                        ),
                        title: Text(
                          students[index].name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'ID: ${students[index].id} • '
                          'Age: ${students[index].age} • '
                          'Department: ${students[index].department}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  editingIndex = index;
                                  nameController.text = students[index].name;
                                  idController.text = students[index].id;
                                  ageController.text = students[index].age;
                                  departmentController.text =
                                      students[index].department;

                                  idController.clear();
                                  nameController.clear();
                                  ageController.clear();
                                  departmentController.clear();
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteStudent(students[index].id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
