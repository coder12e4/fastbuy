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

  void loadCategoriesformSearch(String searchQuery, String? sellerId) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      List<Subcategory> list = [];
      emit(SubcategoryListLoading());
      list.clear();
      if (searchQuery.isEmpty) {
        list = [];
      } else {
        QuerySnapshot querySnapshot = await _firestore
            .collection('subcategories')
            .where('userId', isEqualTo: sellerId)
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .get();
        list = querySnapshot.docs.map((doc) {
          return Subcategory.fromMap(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      }
      emit(SubcategoryListSuccess(list));
    } catch (e) {
      emit(SubcategoryFail(e.toString()));
    }
  }
}
