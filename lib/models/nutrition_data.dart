import 'package:flutter/services.dart' show rootBundle;

/// Loads and queries the nutrition CSV (header row + one row per food).
///
/// The first column is `name`; every other column is numeric. Empty cells
/// are treated as missing (`null`) when reading and as `0` when summing.
class NutritionData {
  NutritionData._(this.fieldNames, this._rows);

  /// All column names in file order (including `name`).
  final List<String> fieldNames;

  /// name -> (field -> raw cell text)
  final Map<String, Map<String, String>> _rows;

  static const String nameField = 'name';

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------

  /// Load from a Flutter asset, e.g. `assets/files/nutrition.csv`
  /// (remember to list it under `flutter: assets:` in pubspec.yaml).
  static Future<NutritionData> fromAsset(String assetPath) async {
    final content = await rootBundle.loadString(assetPath);
    return NutritionData.fromString(content);
  }

  /// Parse CSV text that has already been read (from a file, network, etc.).
  factory NutritionData.fromString(String csvText) {
    // Strip a UTF-8 byte-order mark if present (this file has one).
    if (csvText.startsWith('﻿')) csvText = csvText.substring(1);

    final records = _parseCsv(csvText);
    if (records.isEmpty) {
      throw const FormatException('CSV is empty.');
    }

    final header = records.first.map((h) => h.trim()).toList();
    final nameIndex = header.indexOf(nameField);
    if (nameIndex == -1) {
      throw const FormatException('CSV has no "name" column.');
    }

    final rows = <String, Map<String, String>>{};
    for (var r = 1; r < records.length; r++) {
      final record = records[r];
      if (record.length == 1 && record.first.trim().isEmpty) continue; // blank line

      final row = <String, String>{};
      for (var c = 0; c < header.length; c++) {
        row[header[c]] = c < record.length ? record[c] : '';
      }
      rows[row[nameField]!] = row;
    }

    return NutritionData._(List.unmodifiable(header), rows);
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Every `name` value in file order.
  List<String> getNames() => _rows.keys.toList();

  /// Every `name` value that contains [query], in file order.
  ///
  /// Matching ignores case by default; pass `caseSensitive: true` for an
  /// exact-case match. An empty [query] returns all names.
  List<String> searchNames(String query, {bool caseSensitive = false}) {
    if (caseSensitive) {
      return _rows.keys.where((n) => n.contains(query)).toList();
    }
    final q = query.toLowerCase();
    return _rows.keys.where((n) => n.toLowerCase().contains(q)).toList();
  }

  /// Returns the requested [fields] for the entry called [name] as
  /// field name -> value.
  ///
  /// Numeric fields come back as `double`, the `name` field as `String`,
  /// and empty cells as `null`.
  /// Throws [ArgumentError] if [name] or any field doesn't exist.
  Map<String, Object?> getFieldValues(String name, List<String> fields) {
    final row = _rows[name];
    if (row == null) {
      throw ArgumentError.value(name, 'name', 'No entry with this name');
    }
    _checkFields(fields);

    final result = <String, Object?>{};
    for (final field in fields) {
      final raw = row[field]!;
      result[field] = field == nameField ? raw : _toDouble(raw, field, name);
    }
    return result;
  }

  /// Sums each of [fields] across all entries in [names] and returns
  /// field name -> total. Empty cells count as 0.
  ///
  /// Throws [ArgumentError] if a name or field doesn't exist, or if the
  /// `name` field is requested (it can't be summed).
  Map<String, double> sumFields(List<String> names, List<String> fields) {
    _checkFields(fields);
    if (fields.contains(nameField)) {
      throw ArgumentError.value(nameField, 'fields', 'Cannot sum the name field');
    }

    final selectedRows = names.map((n) {
      final row = _rows[n];
      if (row == null) {
        throw ArgumentError.value(n, 'names', 'No entry with this name');
      }
      return row;
    }).toList();

    final totals = <String, double>{for (final f in fields) f: 0.0};
    for (final row in selectedRows) {
      for (final field in fields) {
        final name = row[nameField]!;
        totals[field] = totals[field]! + (_toDouble(row[field]!, field, name) ?? 0.0);
      }
    }
    return totals;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _checkFields(List<String> fields) {
    final unknown = fields.where((f) => !fieldNames.contains(f)).toList();
    if (unknown.isNotEmpty) {
      throw ArgumentError.value(unknown.join(', '), 'fields', 'Unknown field(s)');
    }
  }

  static double? _toDouble(String raw, String field, String name) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    final value = double.tryParse(text);
    if (value == null) {
      throw FormatException('Non-numeric value "$raw" in "$field" for "$name"');
    }
    return value;
  }

  /// Minimal RFC 4180 CSV parser: handles quoted fields containing commas,
  /// escaped quotes ("") and newlines, plus \n or \r\n line endings.
  static List<List<String>> _parseCsv(String text) {
    final records = <List<String>>[];
    var record = <String>[];
    final field = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < text.length; i++) {
      final ch = text[i];

      if (inQuotes) {
        if (ch == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            inQuotes = false;
          }
        } else {
          field.write(ch);
        }
        continue;
      }

      switch (ch) {
        case '"':
          inQuotes = true;
          break;
        case ',':
          record.add(field.toString());
          field.clear();
          break;
        case '\r':
          break; // ignored; '\n' ends the record
        case '\n':
          record.add(field.toString());
          field.clear();
          records.add(record);
          record = <String>[];
          break;
        default:
          field.write(ch);
      }
    }

    // Last record if the file doesn't end with a newline.
    if (field.isNotEmpty || record.isNotEmpty) {
      record.add(field.toString());
      records.add(record);
    }
    return records;
  }
}
