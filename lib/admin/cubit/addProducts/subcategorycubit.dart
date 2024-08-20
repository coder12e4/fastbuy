import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';

class SubcategoryCubit extends Cubit<List<Subcategory>> {
  SubcategoryCubit() : super([]);

  void fetchSubcategories(String categoryId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('subcategories')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      List<Subcategory> subcategories = snapshot.docs
          .map(
            (doc) => Subcategory.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();

      emit(subcategories);
    } catch (e) {
      print(e);
    }
  }

  void addSubcategory(Subcategory subcategory) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('subcategories')
          .add(subcategory.toMap());
      subcategory = Subcategory(
          id: docRef.id,
          name: subcategory.name,
          categoryId: subcategory.categoryId,
          userId: subcategory.userId);

      emit([...state, subcategory]);
    } catch (e) {
      print(e);
    }
  }
}
