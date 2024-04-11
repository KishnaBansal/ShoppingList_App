import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  var _isLoading = true;
  String? _error;
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('flutter-shopping-56656-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = "Failed to fetch data,Please try again";
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> _loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (catItem) => catItem.value.title == item.value['category'],
          )
          .value;
      _loadedItems.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category),
      );
    }
    setState(() {
      _groceryItems = _loadedItems;
      _isLoading = false;
    });
  }

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

    _loadItems();
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    final url = Uri.https('flutter-shopping-56656-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json'); //We used slash here to not delete the entire list but only a specififc item according to its id

    final response = await http.delete(url);
    setState(() {
      _groceryItems.remove(item);
    });
    if (response.statusCode >= 400) {
      //Optional show : error message if by chance deletion is not possible at backend
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("NO ITEMS"),
    );
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
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
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(214, 255, 255, 255)),
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
                    //   setState(() {
                    //     _groceryItems.removeAt(index);
                    //   });
                    _removeItem(_groceryItems.removeAt(index));
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
