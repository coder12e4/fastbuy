import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../../admin/adminModels/addProductModel/addproduct.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  SubcategoriesCubit() : super(SubcategoriesInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> GetAllSubCategoriesById(String categoryId) async {
    try {
      emit(SubcategoriesLoading());
      QuerySnapshot querySnapshot = await _firestore
          .collection('subcategories')
          .where("categoryId", isEqualTo: categoryId)
          .get();

      List<Subcategory> listCategoris = querySnapshot.docs
          .map((doc) =>
              Subcategory.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      emit(SubcategoriesSuccess(listCategoris));
    } catch (e) {
      emit(SubcategoriesFailed());
      print('Error fetching categoris: $e');
    }
  }
}
