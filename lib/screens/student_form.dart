import 'package:flutter/material.dart';
import 'package:student_registration/models/student.dart';
//import 'package:student_registration/models/student.dart';

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
  final List<Map<String, String>> students = [];
  int? editingIndex;

  @override
  void dispose() {
    nameController.dispose();
    departmentController.dispose();
    idController.dispose();
    ageController.dispose();
    super.dispose();
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
                          //see if it works on list
                          if (nameController.text.trim().isEmpty ||
                              idController.text.trim().isEmpty ||
                              ageController.text.trim().isEmpty ||
                              departmentController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Fields can't be empty!"),
                                backgroundColor: Colors.deepOrangeAccent,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            setState(() {
                              students.add({
                                'name': nameController.text,
                                'id': idController.text,
                                'age': ageController.text,
                                'department': departmentController.text,
                              });
                            });
                            idController.clear();
                            nameController.clear();
                            ageController.clear();
                            departmentController.clear();
                          }
                        },
                        //Registration
                        child: const Icon(Icons.app_registration),
                      ),
                      if (students.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (editingIndex != null) {
                                students[editingIndex!]['name'] =
                                    nameController.text;
                                students[editingIndex!]['id'] =
                                    idController.text;
                                students[editingIndex!]['department'] =
                                    departmentController.text;
                                students[editingIndex!]['age'] =
                                    ageController.text;
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
                          students[index]['name']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'ID: ${students[index]['id']} • '
                          'Age: ${students[index]['age']} • '
                          'Department: ${students[index]['department']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                editingIndex = index;
                                nameController.text = students[index]['name']!;
                                idController.text = students[index]['id']!;
                                ageController.text = students[index]['age']!;
                                departmentController.text =
                                    students[index]['department']!;
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
