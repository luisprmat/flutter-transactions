import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_transactions/models/category.dart';
import 'package:flutter_transactions/models/transaction.dart';
import 'package:flutter_transactions/providers/category_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionEdit extends StatefulWidget {
  final Transaction transaction;
  final Function transactionCallback;

  const TransactionEdit(
    this.transaction,
    this.transactionCallback, {
    super.key,
  });

  @override
  TransactionEditState createState() => TransactionEditState();
}

class TransactionEditState extends State<TransactionEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final transactionAmountController = TextEditingController();
  final transactionCategoryController = TextEditingController();
  final transactionDescriptionController = TextEditingController();
  final transactionDateController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    transactionAmountController.text = widget.transaction.amount.toString();
    transactionCategoryController.text =
        widget.transaction.categoryId.toString();
    transactionDescriptionController.text =
        widget.transaction.description.toString();
    transactionDateController.text =
        widget.transaction.transactionDate.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 10, right: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: transactionAmountController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^-?(\d+\.?\d{0,2})?'),
                ),
              ],
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
                icon: Icon(Icons.attach_money),
                hintText: '0',
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Amount is required';
                }
                final newValue = double.tryParse(value);
                if (newValue == null) {
                  return 'Invalid amount format';
                }
                return null;
              },
              onChanged: (text) => setState(() => errorMessage = ''),
            ),
            SizedBox(height: 20),
            buildCategoriesDropdown(),
            SizedBox(height: 20),
            TextFormField(
              controller: transactionDescriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
              onChanged: (text) => setState(() => errorMessage = ''),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: transactionDateController,
              onTap: () {
                selectDate(context);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Transaction date',
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Date is required';
                }
                return null;
              },
              onChanged:
                  (text) => setState(() {
                    errorMessage = '';
                  }),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Save'),
                  onPressed: () => saveTransaction(context),
                ),
              ],
            ),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null) {
      setState(() {
        transactionDateController.text = DateFormat(
          'MM/dd/yyyy',
        ).format(picked);
      });
    }
  }

  Widget buildCategoriesDropdown() {
    return Consumer<CategoryProvider>(
      builder: (context, cProvider, child) {
        List<Category> categories = cProvider.categories;
        return DropdownButtonFormField(
          elevation: 8,
          items:
              categories.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem<String>(
                  value: e.id.toString(),
                  child: Text(
                    e.name,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue == null) {
              return;
            }
            setState(() {
              transactionCategoryController.text = newValue.toString();
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Category',
          ),
          dropdownColor: Colors.white,
          validator: (value) {
            if (value == null) {
              return 'Please select category';
            }
            return null;
          },
        );
      },
    );
  }

  Future saveTransaction(context) async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    widget.transaction.amount = transactionAmountController.text;
    widget.transaction.categoryId = int.parse(
      transactionCategoryController.text,
    );
    widget.transaction.description = transactionDescriptionController.text;
    widget.transaction.transactionDate = transactionDateController.text;

    await widget.transactionCallback(widget.transaction);

    Navigator.pop(context);
  }
}
