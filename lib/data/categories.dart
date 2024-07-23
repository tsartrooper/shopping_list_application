import 'package:flutter/material.dart';


import '/models/category.dart';

const categories = {
  Categories.vegetables: Category(
    'vegetables',
    Color.fromARGB(255,0,255,128)
  ),
  Categories.fruit: Category(
      'fruits',
      Color.fromARGB(255, 145, 255, 0)
  ),
  Categories.meat: Category(
      'meat',
      Color.fromARGB(255, 255, 102, 0)
  ),
  Categories.dairy: Category(
      'dairy',
      Color.fromARGB(255, 0, 208, 255)
  ),
  Categories.carbs: Category(
      'carbs',
      Color.fromARGB(255, 0, 60, 25)
  ),
  Categories.sweets: Category(
      'sweets',
      Color.fromARGB(255, 255, 149, 0)
  ),
  Categories.spices: Category(
      'spices',
      Color.fromARGB(255, 255, 187, 0)
  ),
  Categories.convenience: Category(
      'convenience',
      Color.fromARGB(255, 191, 0, 255)
  ),
  Categories.other: Category(
      'other',
      Color.fromARGB(255, 0, 225, 255)
  )
};
