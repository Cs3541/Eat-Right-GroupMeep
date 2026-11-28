import 'package:flutter/material.dart';

class SelectedItem {
  final String name;
  final TextEditingController amountController;

  SelectedItem({required this.name, String initialAmount = '1'})
      : amountController = TextEditingController(text: initialAmount);

  // Clean up the controller when the item is removed
  void dispose() {
    amountController.dispose();
  }
}

class ItemSelectorScreen extends StatefulWidget {
  const ItemSelectorScreen({super.key});

  @override
  State<ItemSelectorScreen> createState() => _ItemSelectorScreenState();
}

class _ItemSelectorScreenState extends State<ItemSelectorScreen> {
  // 1. Your master list of searchable items
  final List<String> _allItems = [
    'Apples',
    'Bananas',
    'Carrots',
    'Chicken Breast',
    'Olive Oil',
    'Rice',
    'Tomatoes',
  ];

  // 2. Your new list holding selected items + their amounts
  final List<SelectedItem> _selectedItems = [];

  void _addItem(String itemName) {
    // Optional: Prevent duplicates
    if (_selectedItems.any((item) => item.name == itemName)) return;

    setState(() {
      _selectedItems.add(SelectedItem(name: itemName));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _selectedItems[index].dispose();
      _selectedItems.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var item in _selectedItems) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Items & Amounts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // SEARCH BAR
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _allItems.where((item) => item
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                _addItem(selection);
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Search items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // SELECTED LIST WITH AMOUNT INPUTS
            Expanded(
              child: ListView.builder(
                itemCount: _selectedItems.length,
                itemBuilder: (context, index) {
                  final item = _selectedItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          // Item Name
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          // Amount Text Box
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: item.amountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                labelText: 'Qty',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          // Delete Button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
