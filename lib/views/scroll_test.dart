import 'package:flutter/material.dart';


class ScrollTestScreen extends StatefulWidget {
  const ScrollTestScreen({super.key});

  @override
  State<ScrollTestScreen> createState() => _ScrollTestScreenState();
}

class _ScrollTestScreenState extends State<ScrollTestScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedValue;

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
            DropdownButtonFormField<String>(
              isExpanded: true, // Prevents horizontal overflow
              decoration: const InputDecoration(
                labelText: 'Select an option',
                border: OutlineInputBorder(),
              ),
              initialValue: selectedValue,
              items: ['Option 1', 'Option 2', 'A very long option text that might overflow']
                  .map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}