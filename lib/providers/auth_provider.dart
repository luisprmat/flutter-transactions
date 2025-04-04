import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_transactions/services/api.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  late String token;
  ApiService apiService = ApiService('', null);
  final storage = FlutterSecureStorage();

  AuthProvider() {
    getToken().then((value) {
      if (value.isNotEmpty) {
        token = value;
        isAuthenticated = true;
        notifyListeners();
      }
    });
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirm,
    String deviceName,
  ) async {
    token = await apiService.register(
      name,
      email,
      password,
      passwordConfirm,
      deviceName,
    );

    setToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(String email, String password, String deviceName) async {
    token = await apiService.login(email, password, deviceName);

    setToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    // TODO: Call API to destroy token
    token = '';
    isAuthenticated = false;
    await storage.delete(key: token);
    notifyListeners();
  }

  Future<String> getToken() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token != null) {
        return token;
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<String> setToken(String token) async {
    await storage.write(key: 'token', value: token);

    return token;
  }
}
