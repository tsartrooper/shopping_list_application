import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/data/categories.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/models/grocery_item.dart';
import 'package:shop_app/widgets/grocery_list.dart';

class NewItem extends StatefulWidget{
  const NewItem({required this.authentication_key});
  final String authentication_key;

  State<NewItem> createState() => _NewItemState(authentication_key: authentication_key);
}

class _NewItemState extends State<NewItem>{

  _NewItemState({required this.authentication_key});

  final String authentication_key;
  final _formKey = GlobalKey<FormState>();
  var groceryItemList = List<GroceryItem>;
  var enteredName = '';
  var enteredQuantity = 1;
  var selectedCategory = categories[Categories.vegetables]!;

  void saveItem(String authentication_key) async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      print('loading items');
      print(selectedCategory.title);
      final url = Uri.http('10.0.2.2:5005', '/groceryItem');
      final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authentication_key',

        },
        body: jsonEncode({
        'quantity': enteredQuantity.toString(),
        'name': enteredName,
        'category': selectedCategory.title
        }),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        Navigator.of(context).pop();
      }
    }
  }

  void resetItem(){
    _formKey.currentState!.reset();
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value){
                  if(value == null || value.isEmpty || value.trim().length <= 1 || value.trim().length >= 50){
                    return 'the length must be between 2 to 50';
                  }
                  return null;
                },
                onSaved:  (value){
                  enteredName = value!;
                  } ,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                  Expanded(child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Quantity'),
                    ),
                    initialValue: enteredQuantity.toString(),
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value == null || value.isEmpty
                      || int.parse(value) == null || int.parse(value)!  <= 0 ){
                        return 'the length must be between 2 to 50';
                      }
                    },
                    onSaved: (value){
                      enteredQuantity = int.parse(value!);
                    },
                  ),
                  ),
                   const SizedBox(width: 8),
                   Expanded(child: DropdownButtonFormField(
                     value: selectedCategory,
                     items: [
                         for (final category in categories.entries)
                          DropdownMenuItem(
                          value: category.value,
                             child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: category.value.color,
                              ),
                              const SizedBox(width: 6),
                              Text(category.value.title),
                           ]
                       ))
                   ], onChanged: (value){
                       setState(() {
                         selectedCategory = value!;
                       });
                   }),
                   ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                  TextButton(onPressed: (){
                    resetItem();
                  }, child: Text('Reset')),
                  ElevatedButton(onPressed: (){
                    saveItem(authentication_key);
                  },
                  child: Text("Add Item"))
                ]
              )
            ],
          ),
        ),
      )
    );
  }
}