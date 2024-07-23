import 'package:flutter/material.dart';
import 'package:shop_app/models/category.dart';


class GroceryItem{

  final String name, id;
  final int quantity;
  final Category category;

  const GroceryItem({required this.id, required this.name, required this.quantity, required this.category});
}