import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../adminModels/addProductModel/addproduct.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  void fetchCategories(String userId) async {
    emit(CategoryAddLoading());
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("userId", isEqualTo: userId)
        .get();
    List<Category> categories = snapshot.docs
        .map(
          (doc) => Category.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
    emit(CategorySuccess(categories));
  }

  void chageToAdd() {
    emit(CategoryAddInitial());
  }

  void addCategory(Category category, String userid, String image) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('categories')
          .add(category.toMap());
      category = Category(
          id: docRef.id, name: category.name, userId: userid, image: '');
      fetchCategories(userid);
    } catch (e) {}
  }

  void loadCategoriesformSearch(String searchQuery, String? sellerId) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      List<Category> list = [];
      emit(CategoryAddLoading());
      list.clear();
      if (searchQuery.isEmpty) {
        list = [];
      } else {
        QuerySnapshot querySnapshot = await _firestore
            .collection('categories')
            .where('userId', isEqualTo: sellerId)
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
            .get();
        list = querySnapshot.docs.map((doc) {
          return Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      }
      emit(CategorySuccess(list));
    } catch (e) {
      emit(CategorySearchFail());
    }
  }
}
