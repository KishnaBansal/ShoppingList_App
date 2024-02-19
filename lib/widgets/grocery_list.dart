import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
              width: 17,
              height: 17,
              color: groceryItems[index].category.color,
            ),
            trailing: Text(
              groceryItems[index].quantity.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          );
        },
      ),
    );
  }
}
