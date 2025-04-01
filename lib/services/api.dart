import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_transactions/models/category.dart';

class ApiService {
  ApiService();

  final String baseUrl =
      'http://10.0.2.2:8000'; // from localhost `php artisan serve`
  // final String baseUrl = 'https://tight-optimum-weasel.ngrok-free.app/api/categories'; // from my ngrok

  Future<List<Category>> fetchCategories() async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/api/categories'),
    );

    final Map<String, dynamic> data = json.decode(response.body);

    if (!data.containsKey('data') || data['data'] is! List) {
      throw Exception('Failed to load categories');
    }

    List categories = data['data'];

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future saveCategory(id, name) async {
    String url = '$baseUrl/api/categories/$id';

    final http.Response response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }
}
