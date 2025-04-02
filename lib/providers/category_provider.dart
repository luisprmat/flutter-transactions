import 'package:flutter/material.dart';
import 'package:flutter_transactions/models/category.dart';
import 'package:flutter_transactions/services/api.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];
  late ApiService apiService;

  CategoryProvider() {
    apiService = ApiService();
    init();
  }

  Future init() async {
    try {
      categories = await apiService.fetchCategories();
    } catch (e) {
      print('Failed to load categories: $e');
    }

    notifyListeners();
  }

  Future updateCategory(Category category) async {
    try {
      Category updatedCategory = await apiService.saveCategory(category);
      int index = categories.indexOf(category);
      categories[index] = updatedCategory;
      
      notifyListeners();
    } catch (e) {
      print('Failed to update category: $e');
    }
  }
}
