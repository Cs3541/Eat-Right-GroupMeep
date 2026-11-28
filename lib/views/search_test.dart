import 'package:flutter/material.dart';

class SearchableListScreen extends StatefulWidget {
  const SearchableListScreen({super.key});

  @override
  State<SearchableListScreen> createState() => _SearchableListScreenState();
}

class _SearchableListScreenState extends State<SearchableListScreen> {
  // 1. Master list of all items
  final List<String> _allItems = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
  ];

  // 2. List that holds the filtered results
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    // Show all items initially
    _filteredItems = _allItems;
  }

  // 3. Filter logic triggered on text change
  void _runFilter(String enteredKeyword) {
    List<String> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allItems;
    } else {
      results = _allItems
          .where((item) =>
              item.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(_filteredItems[index]),
                      ),
                    )
                  : const Text('No results found'),
            ),
          ],
        ),
      ),
    );
  }
}