class Student{
  String id;
  String name;
  String age;
  String department;
  

  Student({
  required this.id,
  required this.name,
  required this.age,
  required this.department,
});

 factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      department: json['department'],
    );
}

}