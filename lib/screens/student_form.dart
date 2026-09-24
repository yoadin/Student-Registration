import 'package:flutter/material.dart';
import 'package:student_registration/models/student.dart';
import 'package:http/http.dart' as http;

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
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
        Uri.parse('http://192.168.140.159/student_api/register_student.php'),
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

      print(response.body);
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
                          //see if it works on php
                          registerStudent();
                          // if (nameController.text.trim().isEmpty ||
                          //     idController.text.trim().isEmpty ||
                          //     ageController.text.trim().isEmpty ||
                          //     departmentController.text.trim().isEmpty) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text("Fields can't be empty!"),
                          //       backgroundColor: Colors.deepOrangeAccent,
                          //       duration: Duration(seconds: 2),
                          //     ),
                          //   );
                          // } else {
                          //   setState(() {
                          //     students.add(
                          //       Student(
                          //         id: idController.text,
                          //         name: nameController.text,
                          //         age: ageController.text,
                          //         department: departmentController.text,
                          //       ),
                          //     );
                          //   });
                          //   idController.clear();
                          //   nameController.clear();
                          //   ageController.clear();
                          //   departmentController.clear();
                          // }
                        },
                        //Registration
                        child: const Icon(Icons.app_registration),
                      ),
                      if (editingIndex != null)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (editingIndex != null) {
                                students[editingIndex!].name =
                                    nameController.text;
                                students[editingIndex!].id = idController.text;
                                students[editingIndex!].department =
                                    departmentController.text;
                                students[editingIndex!].age =
                                    ageController.text;

                                editingIndex = null;
                              }
                            });
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
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  students.removeAt(index);
                                });
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
