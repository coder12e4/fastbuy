import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../../adminModels/addProductModel/addproduct.dart';
part 'subcategory_state.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> {
  SubcategoryCubit() : super(SubcategoryInitial());
  void fetchSubcategories(String categoryId) async {
    emit(SubcategoryListLoading());
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

      emit(SubcategoryListSuccess(subcategories));
    } catch (e) {
      print(e);
      emit(SubcategoryFail(e.toString()));
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
          userId: subcategory.userId,
          image: subcategory.image);
      fetchSubcategories(subcategory.categoryId);
    } catch (e) {
      print(e);
    }
  }

  void addSubcategories() {
    emit(SubcategoryAddNewSubcategoryInitial());
  }
}
