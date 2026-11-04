import 'package:flutter/material.dart';


class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // State for Dropdown 1
  String? _selectedSearch;
  final List<String> _searchOptions = ['Title', 'Creator'];

  // State for Dropdown 2
  String? _selectedSort;
  final List<String> _sortOptions = ['Rating', 'Alphabetical(title)', 'Date Posted'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Search Bar at the top
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle search query changes here
              },
            ),
            const SizedBox(height: 16.0),

            // 2. Two Dropdown Menus Next to Each Other
            Row(
              children: [
                // First Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedSearch,
                    decoration: InputDecoration(
                      labelText: 'Search By',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    ),
                    items: _searchOptions.map((String search) {
                      return DropdownMenuItem<String>(
                        value: search,
                        child: Text(search),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSearch = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12.0), // Spacing between dropdowns

                // Second Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedSort,
                    decoration: InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    ),
                    items: _sortOptions.map((String sort) {
                      return DropdownMenuItem<String>(
                        value: sort,
                        child: Text(sort, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSort = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Display area showing current selections
            Expanded(
              child: Center(
                child: Text(
                  'Search: "${_searchController.text}"\n'
                  'Search By: ${_selectedSearch ?? "None"}\n'
                  'Sort By: ${_selectedSort ?? "None"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
