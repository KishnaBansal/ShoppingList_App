import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: _groceryItems.isEmpty
          ? const Center(
              child: Text(
                "Oops! 🙊 Your shopping list is currently empty 📝",
                style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(214, 255, 255, 255)),
              ),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) {
                final it = _groceryItems.elementAt(index);
                return Dismissible(
                  key: Key(it.id),
                  background: Container(
                    color: Colors.red.withOpacity(0.3),
                    alignment: Alignment.centerRight,
                    //padding: const EdgeInsets.only(right: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.delete_sweep_rounded,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.delete_sweep_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _groceryItems.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Item deleted"),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            setState(
                              () {
                                _groceryItems.insert(
                                  index,
                                  it,
                                );
                              },
                            );
                          },
                        ),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(_groceryItems[index].name),
                    leading: Container(
                      width: 17,
                      height: 17,
                      color: _groceryItems[index].category.color,
                    ),
                    trailing: Text(
                      _groceryItems[index].quantity.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
