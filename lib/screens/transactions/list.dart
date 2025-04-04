import 'package:flutter/material.dart';
import 'package:flutter_transactions/models/transaction.dart';
import 'package:flutter_transactions/providers/transaction_provider.dart';
import 'package:flutter_transactions/widgets/transaction_add.dart';
import 'package:flutter_transactions/widgets/transaction_edit.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    List<Transaction> transactions = provider.transactions;

    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          Transaction transaction = transactions[index];
          return ListTile(
            title: Text('\$ ${transaction.amount}'),
            subtitle: Text(transaction.categoryName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(transaction.transactionDate),
                    Text(transaction.description),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return TransactionEdit(
                          transaction,
                          provider.updateTransaction,
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you sure you want to delete?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed:
                                  () => deleteTransaction(
                                    provider.deleteTransaction,
                                    transaction,
                                    context,
                                  ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return TransactionAdd(provider.addTransaction);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> deleteTransaction(
    Function callback,
    Transaction transaction,
    context,
  ) async {
    await callback(transaction);
    Navigator.pop(context);
  }
}
