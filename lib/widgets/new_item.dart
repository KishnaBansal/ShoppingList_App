import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItem();
}

class _NewItem extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Form Field"),
      ),
    );
  }
}
