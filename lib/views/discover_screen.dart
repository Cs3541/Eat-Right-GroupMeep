// import 'package:flutter/material.dart';

// class DiscoverScreen extends StatefulWidget {
//   const DiscoverScreen({super.key});

//   @override
//   State<DiscoverScreen> createState() => _DiscoverScreenState();
// }

// class _DiscoverScreenState extends State<DiscoverScreen> {
//   // Your data source array
//   final List<String> _allItems = [
//     'Apple', 'Banana', 'Blueberry', 'Cherry', 'Date', 
//     'Elderberry', 'Fig', 'Grape', 'Honeydew'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Demo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // SearchAnchor coordinates the search bar and the search view overlay
//             SearchAnchor(
//               builder: (BuildContext context, SearchController controller) {
//                 return SearchBar(
//                   controller: controller,
//                   padding: const WidgetStatePropertyAll<EdgeInsets>(
//                     EdgeInsets.symmetric(horizontal: 16.0),
//                   ),
//                   onTap: () {
//                     controller.openView(); // Opens the full search view overlay
//                   },
//                   onChanged: (_) {
//                     controller.openView();
//                   },
//                   leading: const Icon(Icons.search),
//                   hintText: 'Search fruits...',
//                 );
//               },
//               suggestionsBuilder: (BuildContext context, SearchController controller) {
//                 // Get the current text typed by the user
//                 final String keyword = controller.text.toLowerCase();

//                 // Filter items based on user input
//                 final List<String> matches = _allItems.where((item) {
//                   return item.toLowerCase().contains(keyword);
//                 }).toList();

//                 // If nothing matches, return a "No results" visual indicator
//                 if (matches.isEmpty) {
//                   return [
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       key: ValueKey('no_results'),
//                       child: Center(child: Text('No results found.')),
//                     )
//                   ];
//                 }

//                 // Map matched items into a list of interactive widgets
//                 return matches.map((String item) {
//                   return ListTile(
//                     title: Text(item),
//                     onTap: () {
//                       setState(() {
//                         controller.closeView(item); // Update bar text and close
//                       });
//                     },
//                   );
//                 }).toList();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }