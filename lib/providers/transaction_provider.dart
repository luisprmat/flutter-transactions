import 'package:flutter/material.dart';
import 'package:flutter_transactions/models/transaction.dart';
import 'package:flutter_transactions/providers/auth_provider.dart';
import 'package:flutter_transactions/services/api.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> transactions = [];
  late ApiService apiService;
  late AuthProvider authProvider;

  TransactionProvider(AuthProvider auth) {
    authProvider = auth;
    init();
  }

  Future init() async {
    apiService = ApiService(await authProvider.getToken(), authProvider);
    transactions = await apiService.fetchTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(
    String amount, String category, String description, String date) async {
    try {
      Transaction addedTransaction =
        await apiService.addTransaction(amount, category, description, date);
      transactions.add(addedTransaction);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
 
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      Transaction updatedTransaction =
        await apiService.updateTransaction(transaction);
      int index = transactions.indexOf(transaction);
      transactions[index] = updatedTransaction;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
 
  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      await apiService.deleteTransaction(transaction.id);
      transactions.remove(transaction);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
