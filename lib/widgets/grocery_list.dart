import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/category.dart';

import 'package:shop_app/widgets/new_item.dart';
import 'package:shop_app/models/grocery_item.dart';
import 'package:shop_app/data/categories.dart';


class GroceryList extends StatefulWidget {
  const GroceryList({required this.authentication_key});
  final String authentication_key;

  State<GroceryList> createState() => _GroceryListState(authentication_key: authentication_key);
}

class _GroceryListState extends State<GroceryList>{

  List<GroceryItem> _groceryItems = [];
  _GroceryListState({required this.authentication_key});
  final String authentication_key;


  @override
  void initState() {
    // TODO: implement initState
    _loadItems(authentication_key);
  }

  Widget content = const Center(child: Text("No items added yet."));

  void _addItem() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewItem(authentication_key: authentication_key)));
    // if(newItem == null){
    //   return;
    // }
    // setState(() {
      // _groceryItems.add(newItem);
    // });
    _loadItems(authentication_key);
  }
  
  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.http('10.0.2.2:5000', '/groceryItem/'+item.id);
    final response = await http.delete(url,
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authentication_key'
        },
    );
  if(response.statusCode >= 400) {
    setState(() {
      _groceryItems.insert(index, item);
    });
  }
  }

  void _loadItems(String authentication_key) async {
    print('loading items');
    final url = Uri.http('10.0.2.2:5000', '/groceryItem');
    final response = await http.get(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authentication_key'
      },
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      final List<dynamic> responseData = json.decode(response.body);
      var item;
      List<GroceryItem> loadedItems = [];
      for(item in responseData){
        print(item);
        print(item['category']);
       final category = categories.entries.firstWhere((catValue) => catValue.value.title == item['category']).value;
        loadedItems.add(GroceryItem(id: item['id'], name: item['name'], quantity: item['quantity'], category: category));
      }
      setState(() {
        _groceryItems = loadedItems;
      });
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (ctx) => const GroceryList(access_token)),
      // );
    }
  }

  @override
  Widget build(BuildContext context){
    if(_groceryItems.isNotEmpty){
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction){
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
        ],
      ),
      body: content
    );
  }
}