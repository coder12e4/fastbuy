import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  String baseUrl;
  ApiServices(this.baseUrl);
  Future<Map<String, dynamic>> getData() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
