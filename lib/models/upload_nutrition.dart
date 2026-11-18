
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Firestore allows at most 500 writes per batch.
const int _batchSize = 500;

/// Reads the CSV from the app's assets and writes one document per row.
Future<void> uploadNutritionCsv({
  String assetPath = 'assets/nutrition.csv',
  String collection = 'nutrition',
  void Function(int done, int total)? onProgress,
}) async {
  final raw = await rootBundle.loadString(assetPath);
  final rows = parseCsv(raw);
  if (rows.isEmpty) throw StateError('CSV is empty');

  final header = rows.first.map((h) => h.trim()).toList();
  final dataRows = rows
      .skip(1)
      .where((r) => r.any((c) => c.isNotEmpty))
      .toList();

  final nameIndex = header.indexOf('name');
  if (nameIndex < 0) throw StateError('CSV has no "name" column');

  final firestore = FirebaseFirestore.instance;
  final col = firestore.collection(collection);

  for (var start = 0; start < dataRows.length; start += _batchSize) {
    final end = (start + _batchSize).clamp(0, dataRows.length);
    final batch = firestore.batch();

    for (final row in dataRows.sublist(start, end)) {
      final id = documentIdForName(row[nameIndex]);
      batch.set(col.doc(id), rowToDocument(header, row));
    }

    await batch.commit();
    onProgress?.call(end, dataRows.length);
  }
}

/// Document ID for a food: its trimmed name with "/" replaced by "|", since
/// Firestore reads "/" as a path separator. Use this to look up a food by
/// name, e.g. `col.doc(documentIdForName('Nuts, pecans'))`.
String documentIdForName(String name) {
  final id = name.trim().replaceAll('/', '|');
  if (id.isEmpty) throw StateError('Row has an empty name');
  return id;
}

/// Turns one CSV row into a Firestore document map.
Map<String, dynamic> rowToDocument(List<String> header, List<String> row) {
  final doc = <String, dynamic>{};

  for (var i = 0; i < header.length && i < row.length; i++) {
    final field = header[i];
    final cell = row[i].trim();
    if (field.isEmpty || cell.isEmpty) continue;

    if (field == 'name') {
      doc['name'] = cell;
      doc['name_lower'] = cell.toLowerCase();
    } else {
      // Every value is a plain number now; keep the text if one isn't.
      doc[field] = num.tryParse(cell) ?? cell;
    }
  }
  return doc;
}

/// Minimal RFC 4180 CSV parser: handles quoted fields, escaped quotes (""),
/// commas/newlines inside quotes, CRLF line endings and a UTF-8 BOM.
List<List<String>> parseCsv(String input) {
  if (input.startsWith('﻿')) input = input.substring(1);

  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < input.length; i++) {
    final c = input[i];

    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < input.length && input[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      inQuotes = true;
    } else if (c == ',') {
      row.add(field.toString());
      field.clear();
    } else if (c == '\n' || c == '\r') {
      if (c == '\r' && i + 1 < input.length && input[i + 1] == '\n') i++;
      row.add(field.toString());
      field.clear();
      rows.add(row);
      row = <String>[];
    } else {
      field.write(c);
    }
  }

  if (field.isNotEmpty || row.isNotEmpty) {
    row.add(field.toString());
    rows.add(row);
  }
  return rows;
}
