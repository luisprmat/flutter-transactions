import 'package:flutter/material.dart';
import 'package:flutter_transactions/providers/auth_provider.dart';
import 'package:flutter_transactions/screens/categories/categories_list.dart';
import 'package:flutter_transactions/screens/transactions/list.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = [Transactions(), CategoriesList()];

  Future<void> onItemTapped(int index) async {
    if (index == 2) {
      final AuthProvider provider = Provider.of<AuthProvider>(
        context,
        listen: false,
      );
      await provider.logout();
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  Future<void> logout() async {
    final AuthProvider provider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    await provider.logout();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4,
          child: OverflowBox(
            maxHeight: double.infinity,
            child: BottomNavigationBar(
              backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
              elevation: 0,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Transactions',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout),
                  label: 'Log out',
                ),
              ],
              currentIndex: selectedIndex,
              onTap: onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
