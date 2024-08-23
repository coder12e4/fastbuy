import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';
import 'package:meta/meta.dart';

part 'home_user_state.dart';

class HomeUserCubit extends Cubit<HomeUserState> {
  HomeUserState homeUserState;
  HomeUserCubit(this.homeUserState) : super(HomeUserInitial());
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> LoadHome() async {
    emit(HomeUserLoading());
    try {
      List<Product> listProducts = await GetAllProducts();
      List<Category> listCategoris = await GetAllCategories();
      emit(HomeUserSucess(listProducts, listCategoris));
    } catch (e) {
      emit(HomeUserFail());
    }
  }

  Future<List<Product>> GetAllProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();

      return querySnapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Category>> GetAllCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories').get();

      return querySnapshot.docs
          .map((doc) =>
              Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> GetAllSubCategoriesById(String categoryId) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();

      List<Category> listCategoris = querySnapshot.docs
          .map((doc) =>
              Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching categoris: $e');
    }
  }
}
