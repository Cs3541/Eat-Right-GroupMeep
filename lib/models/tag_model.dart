import 'package:cloud_firestore/cloud_firestore.dart';


class Tag {
    final String tagName;

    Tag({required this.tagName});
    
    static final _firestore = FirebaseFirestore.instance;

    static Future<List<Tag>> fetchTags() async {

      final snapshot = await _firestore.collection('tags').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Tag(
          tagName: data['tagName'],
        );
      }).toList();
    }

    static Future<void> addTag(String tagName) async {
      await _firestore.collection('tags').add({
        'tagName': tagName,
      });
    }
}