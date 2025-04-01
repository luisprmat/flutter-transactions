import 'package:flutter/material.dart';
import 'package:flutter_transactions/models/category.dart';
import 'package:flutter_transactions/services/api.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  CategoriesListState createState() => CategoriesListState();
}

class CategoriesListState extends State<CategoriesList> {
  Future<List<Category>>? futureCategories;
  ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  late Category selectedCategory;
  final categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCategories = apiService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories List')),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Category category = snapshot.data![index];

                return ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                    onPressed: () {
                      selectedCategory = category;
                      categoryNameController.text = category.name;
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text('Edit Category'),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Category Name',
                                    ),
                                    controller: categoryNameController,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter category name';
                                      }
                                      return null;
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        apiService.saveCategory(
                                          selectedCategory.id,
                                          categoryNameController.text,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Update'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
