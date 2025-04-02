import 'package:flutter/material.dart';
import 'package:flutter_transactions/models/category.dart';
import 'package:flutter_transactions/providers/category_provider.dart';
import 'package:flutter_transactions/widgets/category_edit.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  CategoriesListState createState() => CategoriesListState();
}

class CategoriesListState extends State<CategoriesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        List<Category> categories = provider.categories;

        return Scaffold(
          appBar: AppBar(title: Text('Categories List')),
          body: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              Category category = categories[index];

              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return CategoryEdit(category, provider.updateCategory);
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
