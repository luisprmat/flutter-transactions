import 'dart:convert';
import 'package:flutter_transactions/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_transactions/models/category.dart';

class ApiService {
  late String? token;

  ApiService(String token) {
    this.token = token;
  }

  final String baseUrl =
      'http://10.0.2.2:8000'; // from localhost `php artisan serve`
  // final String baseUrl = 'https://tight-optimum-weasel.ngrok-free.app/api/categories'; // from my ngrok

  Future<List<Category>> fetchCategories() async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/api/categories'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    final Map<String, dynamic> data = json.decode(response.body);

    if (!data.containsKey('data') || data['data'] is! List) {
      throw Exception('Failed to load categories');
    }

    List categories = data['data'];

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future saveCategory(Category category) async {
    String url = '$baseUrl/api/categories/${category.id}';

    final http.Response response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'name': category.name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return Category.fromJson(data['data']);
  }

  Future<void> deleteCategory(id) async {
    String url = '$baseUrl/api/categories/$id';

    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }

  Future addCategory(String name) async {
    String url = '$baseUrl/api/categories';

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create category');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return Category.fromJson(data['data']);
  }

  Future register(
    String name,
    String email,
    String password,
    String passwordConfirm,
    String deviceName,
  ) async {
    String url = '$baseUrl/api/auth/register';

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
        'device_name': deviceName,
      }),
    );

    if (response.statusCode == 422) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> errors = data['errors'];
      String message = '';
      errors.forEach((key, value) {
        value.forEach((error) {
          message += '$error\n';
        });
      });

      throw Exception(message);
    }

    return response.body;
  }

  Future login(String email, String password, String deviceName) async {
    String url = '$baseUrl/api/auth/login';

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'device_name': deviceName,
      }),
    );

    if (response.statusCode == 422) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> errors = data['errors'];
      String message = '';
      errors.forEach((key, value) {
        value.forEach((error) {
          message += '$error\n';
        });
      });

      throw Exception(message);
    }

    return response.body;
  }
  
  Future<List<Transaction>> fetchTransactions() async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/api/transactions'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    final Map<String, dynamic> data = json.decode(response.body);

    if (!data.containsKey('data') || data['data'] is! List) {
      throw Exception('Failed to load transactions');
    }

    List transactions = data['data'];

    return transactions.map((transaction) => Transaction.fromJson(transaction)).toList();
  }

  Future addTransaction(String amount, String category, String description, String date) async {
    String url = '$baseUrl/api/transactions';

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'amount': amount,
        'category_id': category,
        'description': description,
        'transaction_date': date,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create transaction');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return Transaction.fromJson(data['data']);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    String uri = '$baseUrl/api/transactions/${transaction.id.toString()}';
    final http.Response response = await http.put(Uri.parse(uri),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'amount': transaction.amount,
        'category_id': transaction.categoryId,
        'description': transaction.description,
        'transaction_date': transaction.transactionDate
      }));
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to update transaction');
    }
    return Transaction.fromJson(jsonDecode(response.body)['data']);
  }

  Future<void> deleteTransaction(id) async {
    String url = '$baseUrl/api/transactions/${id.toString()}';

    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete transaction');
    }
  }
}
