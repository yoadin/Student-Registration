import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {

  static const String baseUrl =
      "http://192.168.0.192/student_api";

  static Future<List<Student>> getStudents() async {

    final response = await http.get(
      Uri.parse("$baseUrl/read.php"),
    );

    if (response.statusCode == 200) {

      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Student.fromJson(json))
          .toList();

    } else {
      throw Exception("Failed to load students");
    }
  }
}