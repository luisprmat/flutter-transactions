import 'package:flutter/material.dart';
import 'package:flutter_transactions/services/api.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  late String token;
  ApiService apiService = ApiService('');

  AuthProvider();

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

    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(
    String email,
    String password,
    String deviceName,
  ) async {
    token = await apiService.login(
      email,
      password,
      deviceName,
    );

    isAuthenticated = true;
    notifyListeners();
  }
}
