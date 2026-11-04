// // upload_nutrition.dart
// //
// // Uploads nutrition.csv (8,789 foods, 77 columns) to a Cloud Firestore
// // collection.
// //
// // Setup (Flutter app):
// //   1. pubspec.yaml
// //        dependencies:
// //          firebase_core: any
// //          cloud_firestore: any
// //        flutter:
// //          assets:
// //            - assets/nutrition.csv
// //   2. Copy the CSV to assets/nutrition.csv
// //   3. Initialise Firebase, then call the upload once, e.g.:
// //
// //        await Firebase.initializeApp(
// //            options: DefaultFirebaseOptions.currentPlatform);
// //        await uploadNutritionCsv(
// //          onProgress: (done, total) => debugPrint('$done / $total'),
// //        );
// //
// //   Your Firestore security rules must allow writes to the collection while
// //   you run this (lock them back down afterwards).
// //
// // What each document looks like (doc ID = the CSV's row index, so re-running
// // overwrites instead of creating duplicates):
// //   {
// //     name: "Nuts, pecans",
// //     name_lower: "nuts, pecans",   // handy for prefix search
// //     serving_size: 100,            // grams
// //     calories: 691,
// //     total_fat: 72,
// //     sodium: 0,
// //     ...
// //   }
// // Values are stored as numbers with the unit stripped; see [nutritionUnits]
// // for each field's unit. Blank cells are omitted from the document.

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart' show rootBundle;

// /// Unit of every numeric field, as found in the CSV.
// const Map<String, String> nutritionUnits = {
//   'serving_size': 'g',
//   'calories': 'kcal',
//   'total_fat': 'g',
//   'saturated_fat': 'g',
//   'cholesterol': 'mg',
//   'sodium': 'mg',
//   'choline': 'mg',
//   'folate': 'mcg',
//   'folic_acid': 'mcg',
//   'niacin': 'mg',
//   'pantothenic_acid': 'mg',
//   'riboflavin': 'mg',
//   'thiamin': 'mg',
//   'vitamin_a': 'IU',
//   'vitamin_a_rae': 'mcg',
//   'carotene_alpha': 'mcg',
//   'carotene_beta': 'mcg',
//   'cryptoxanthin_beta': 'mcg',
//   'lutein_zeaxanthin': 'mcg',
//   'lucopene': 'mcg',
//   'vitamin_b12': 'mcg',
//   'vitamin_b6': 'mg',
//   'vitamin_c': 'mg',
//   'vitamin_d': 'IU',
//   'vitamin_e': 'mg',
//   'tocopherol_alpha': 'mg',
//   'vitamin_k': 'mcg',
//   'calcium': 'mg',
//   'copper': 'mg',
//   'irom': 'mg',
//   'magnesium': 'mg',
//   'manganese': 'mg',
//   'phosphorous': 'mg',
//   'potassium': 'mg',
//   'selenium': 'mcg',
//   'zink': 'mg',
//   'protein': 'g',
//   'alanine': 'g',
//   'arginine': 'g',
//   'aspartic_acid': 'g',
//   'cystine': 'g',
//   'glutamic_acid': 'g',
//   'glycine': 'g',
//   'histidine': 'g',
//   'hydroxyproline': 'g',
//   'isoleucine': 'g',
//   'leucine': 'g',
//   'lysine': 'g',
//   'methionine': 'g',
//   'phenylalanine': 'g',
//   'proline': 'g',
//   'serine': 'g',
//   'threonine': 'g',
//   'tryptophan': 'g',
//   'tyrosine': 'g',
//   'valine': 'g',
//   'carbohydrate': 'g',
//   'fiber': 'g',
//   'sugars': 'g',
//   'fructose': 'g',
//   'galactose': 'g',
//   'glucose': 'g',
//   'lactose': 'g',
//   'maltose': 'g',
//   'sucrose': 'g',
//   'fat': 'g',
//   'saturated_fatty_acids': 'g',
//   'monounsaturated_fatty_acids': 'g',
//   'polyunsaturated_fatty_acids': 'g',
//   'fatty_acids_total_trans': 'mg',
//   'alcohol': 'g',
//   'ash': 'g',
//   'caffeine': 'mg',
//   'theobromine': 'mg',
//   'water': 'g',
// };

// /// Firestore allows at most 500 writes per batch.
// const int _batchSize = 500;

// final RegExp _valuePattern = RegExp(
//   r'^\s*(-?[0-9]*\.?[0-9]+)\s*([A-Za-z]*)\s*$',
// );

// /// Reads the CSV from the app's assets and writes one document per row.
// Future<void> uploadNutritionCsv({
//   String assetPath = 'files/nutrition.csv',
//   String collection = 'nutrition',
//   void Function(int done, int total)? onProgress,
// }) async {
//   final raw = await rootBundle.loadString(assetPath);
//   final rows = parseCsv(raw);
//   if (rows.isEmpty) throw StateError('CSV is empty');

//   final header = rows.first.map((h) => h.trim()).toList();
//   final dataRows = rows
//       .skip(1)
//       .where((r) => r.any((c) => c.isNotEmpty))
//       .toList();

//   final firestore = FirebaseFirestore.instance;
//   final col = firestore.collection(collection);

//   var done = 0;
//   for (var start = 0; start < dataRows.length; start += _batchSize) {
//     final end = (start + _batchSize).clamp(0, dataRows.length);
//     final batch = firestore.batch();

//     for (final row in dataRows.sublist(start, end)) {
//       final id = row[0].trim(); // first column is the unnamed row index
//       final docRef = id.isEmpty ? col.doc() : col.doc(id);
//       batch.set(docRef, rowToDocument(header, row));
//     }

//     await batch.commit();
//     done = end;
//     onProgress?.call(done, dataRows.length);
//   }
// }

// /// Turns one CSV row into a Firestore document map.
// Map<String, dynamic> rowToDocument(List<String> header, List<String> row) {
//   final doc = <String, dynamic>{};

//   for (var i = 1; i < header.length && i < row.length; i++) {
//     final field = header[i];
//     final cell = row[i].trim();
//     if (field.isEmpty || cell.isEmpty) continue;

//     if (field == 'name') {
//       doc['name'] = cell;
//       doc['name_lower'] = cell.toLowerCase();
//       continue;
//     }

//     final match = _valuePattern.firstMatch(cell);
//     if (match == null) {
//       doc[field] = cell; // not a number; keep the text as-is
//       continue;
//     }

//     final number = num.parse(match.group(1)!);
//     final unit = match.group(2)!;
//     final expected = nutritionUnits[field];

//     if (unit.isEmpty || expected == null || unit == expected) {
//       doc[field] = number;
//     } else {
//       // A few rows use a different unit than the rest of the column
//       // (e.g. 7 vitamin_a values in mcg instead of IU). Keep them separate
//       // so the numeric field always means the same unit.
//       doc['${field}_raw'] = cell;
//     }
//   }
//   return doc;
// }

// /// Minimal RFC 4180 CSV parser: handles quoted fields, escaped quotes (""),
// /// commas/newlines inside quotes, CRLF line endings and a UTF-8 BOM.
// List<List<String>> parseCsv(String input) {
//   if (input.startsWith('﻿')) input = input.substring(1);

//   final rows = <List<String>>[];
//   var row = <String>[];
//   final field = StringBuffer();
//   var inQuotes = false;

//   for (var i = 0; i < input.length; i++) {
//     final c = input[i];

//     if (inQuotes) {
//       if (c == '"') {
//         if (i + 1 < input.length && input[i + 1] == '"') {
//           field.write('"');
//           i++;
//         } else {
//           inQuotes = false;
//         }
//       } else {
//         field.write(c);
//       }
//     } else if (c == '"') {
//       inQuotes = true;
//     } else if (c == ',') {
//       row.add(field.toString());
//       field.clear();
//     } else if (c == '\n' || c == '\r') {
//       if (c == '\r' && i + 1 < input.length && input[i + 1] == '\n') i++;
//       row.add(field.toString());
//       field.clear();
//       rows.add(row);
//       row = <String>[];
//     } else {
//       field.write(c);
//     }
//   }

//   if (field.isNotEmpty || row.isNotEmpty) {
//     row.add(field.toString());
//     rows.add(row);
//   }
//   return rows;
// }
