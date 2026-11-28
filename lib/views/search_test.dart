import 'package:flutter/material.dart';

class SearchableListScreen extends StatefulWidget {
  const SearchableListScreen({super.key});

  @override
  State<SearchableListScreen> createState() => _SearchableListScreenState();
}

class _SearchableListScreenState extends State<SearchableListScreen> {
  // 1. Original master list
  final List<String> _allItems = [
    'Apple',
    'Banana',
    'Blueberry',
    'Cherry',
    'Grape',
    'Mango',
    'Orange',
    'Pineapple',
    'Strawberry',
  ];

  // 2. List that holds filtered search results
  List<String> _filteredItems = [];

  // 3. New list for selected items
  final List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all items at startup
    _filteredItems = List.from(_allItems);
  }

  // Filter logic triggered on every keystroke
  void _filterList(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(_allItems);
      } else {
        _filteredItems = _allItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Add or remove item from the new list
  void _toggleSelection(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Select')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              onChanged: _filterList,
              decoration: const InputDecoration(
                labelText: 'Search items',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Display the New List (Selected Items)
            if (_selectedItems.isNotEmpty) ...[
              const Text(
                'Selected List:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: _selectedItems.map((item) {
                  return Chip(
                    label: Text(item),
                    onDeleted: () => _toggleSelection(item),
                  );
                }).toList(),
              ),
              const Divider(height: 24),
            ],

            // Filtered Search Results List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final isSelected = _selectedItems.contains(item);

                  return ListTile(
                    title: Text(item),
                    trailing: Icon(
                      isSelected ? Icons.check_circle : Icons.add_circle_outline,
                      color: isSelected ? Colors.green : null,
                    ),
                    onTap: () => _toggleSelection(item),
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