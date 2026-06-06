import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {
  static const String baseUrl = "https://employee-task-api-xqhv.onrender.com";

  Future<List<dynamic>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to create task");
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> taskData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update task");
    }
  }
}
