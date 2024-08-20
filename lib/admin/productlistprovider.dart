import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final addCategoryProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  final firestore = ref.read(firestoreProvider);
  await firestore.collection('shop').add(data);
});

final categoriesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final firestore = ref.read(firestoreProvider);
  final snapshot = await firestore.collection('shop').get();
  return snapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
});
