// nutritionQuery.dart
//
// Reads back the collection written by upload_nutrition.dart.
//
// Usage (after Firebase.initializeApp):
//
//   final ids = await listFoods();
//   debugPrint('${ids.length} foods');

import 'package:cloud_firestore/cloud_firestore.dart';

/// Number of documents fetched per page. Paging keeps each read small
/// (the collection holds ~8,800 documents with ~77 fields each).
const int _pageSize = 500;

/// Returns every document ID in [collection], sorted alphabetically.
///
/// IDs are unique within a Firestore collection, so the list has no
/// duplicates. With the upload script, each ID is the food's name ('/'
/// replaced by '-', and " (2)", " (3)", ... added to repeated names).
Future<List<String>> listFoods({
  String collection = 'nutrition',
  void Function(int fetched)? onProgress,
}) async {
  final col = FirebaseFirestore.instance.collection(collection);
  final ids = <String>{};

  DocumentSnapshot<Map<String, dynamic>>? last;
  while (true) {
    var query = col.orderBy(FieldPath.documentId).limit(_pageSize);
    if (last != null) query = query.startAfterDocument(last);

    final snapshot = await query.get();
    if (snapshot.docs.isEmpty) break;

    for (final doc in snapshot.docs) {
      ids.add(doc.id);
    }
    onProgress?.call(ids.length);

    if (snapshot.docs.length < _pageSize) break;
    last = snapshot.docs.last;
  }

  return ids.toList()..sort();
}

/// Fetches the document [foodId] and returns one key/value pair per name in
/// [fields], in the same order as [fields].
///
/// The value is null if the food has no value for that field (blank cells
/// were left out at upload). Throws a [StateError] if no document has the
/// ID [foodId].
///
///   final pairs = await getNutrientsFromFood(
///       'Nuts, pecans', ['calories', 'protein', 'sodium']);
///   for (final p in pairs) debugPrint('${p.key}: ${p.value}');
Future<List<MapEntry<String, dynamic>>> getNutrientsFromFood(
  String foodId,
  List<String> fields, {
  String collection = 'nutrition',
}) async {
  final snapshot = await FirebaseFirestore.instance
      .collection(collection)
      .doc(foodId)
      .get();

  final data = snapshot.data();
  if (!snapshot.exists || data == null) {
    throw StateError('No food with ID "$foodId" in "$collection"');
  }

  return [for (final field in fields) MapEntry(field, data[field])];
}
