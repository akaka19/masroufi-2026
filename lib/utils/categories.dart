import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  const Category(this.name, this.icon, this.color);
}

const List<Category> categories = [
  Category('كراء', Icons.home, Colors.blue),
  Category('ماكلة', Icons.restaurant, Colors.orange),
  Category('دو', Icons.medication, Colors.red),
  Category('إنترنت', Icons.wifi, Colors.purple),
  Category('نقل', Icons.directions_bus, Colors.green),
  Category('كهرباء وماء', Icons.bolt, Colors.amber),
  Category('ترفيه', Icons.movie, Colors.pink),
  Category('أخرى', Icons.category, Colors.grey),
];
