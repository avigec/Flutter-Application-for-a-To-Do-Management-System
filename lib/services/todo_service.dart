import 'dart:convert';
import 'package:http/http.dart' as http;

// All todo Api call will be here
class TodoService {
  
  // Delete a task by its ID
  static Future<bool> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response.statusCode == 200;
  }

  //Fetch all tasks
  static Future<List?> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=15';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map; //taking the data in json formet in the MAP form
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  // Update an existing task by its ID
  static Future<bool> updateTodo(String id, Map body) async {
    //Submit data to the Server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body), //in order to send we use body with uri
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  // Add a new task
  static Future<bool> addTodo(Map body) async {
    //Submit data to the Server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body), //in order to send we use body with uri
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}
