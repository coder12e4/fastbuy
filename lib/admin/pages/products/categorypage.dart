import 'dart:io';

import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/admin/cubit/category/category_cubit.dart';
import 'package:fastbuy/admin/cubit/imageUploadButton/image_uploading_button_cubit.dart';
import 'package:fastbuy/admin/pages/products/subcategorypage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatefulWidget {
  final String UserId;
  CategoryPage(this.UserId);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late File? _imageFile;
  bool _isUploading = false;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  List<Category> categories = [];
  late CategoryCubit categoryCubit;
  late ImageUploadingButtonCubit imageUploadingButtonCubit;
  @override
  void initState() {
    categoryCubit = CategoryCubit();
    _imageFile = null;
    categoryCubit.fetchCategories(widget.UserId);
    imageUploadingButtonCubit = ImageUploadingButtonCubit();
    // TODO: implement initState
    super.initState();
  }

  void _addCategory(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String? userid = await context.read<AuthCubit>().getUserId();
      final category =
          Category(id: '', name: _nameController.text, userId: userid!);
      context.read<CategoryCubit>().addCategory(category, userid);
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: BlocProvider<CategoryCubit>(
        create: (context) => CategoryCubit(),
        child: BlocListener<CategoryCubit, CategoryState>(
          bloc: categoryCubit,
          listener: (context, state) {
            if (state is CategoryInitial) {
            } else if (state is CategoryLoading) {
            } else if (state is CategorySuccess) {
              categories = state.categories;
            } else if (state is CategoryFail) {}
          },
          child: BlocBuilder<CategoryCubit, CategoryState>(
            bloc: categoryCubit,
            builder: (context, state) {
              if (state is CategoryInitial) {
                return Container();
              } else if (state is CategoryLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CategorySuccess) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.blueAccent,
                              child: BlocProvider<ImageUploadingButtonCubit>(
                                create: (context) =>
                                    ImageUploadingButtonCubit(),
                                child: BlocListener<ImageUploadingButtonCubit,
                                    ImageUploadingButtonState>(
                                  bloc: imageUploadingButtonCubit,
                                  listener: (context, state) {
                                    if (state is ImageUploadingButtonInitial) {
                                    } else if (state
                                        is ImageUploadingButtonLoading) {
                                    } else if (state
                                        is ImageUploadingButtonSuccess) {
                                    } else if (state
                                        is ImageUploadingButtonFailed) {}
                                  },
                                  child: BlocBuilder<ImageUploadingButtonCubit,
                                      ImageUploadingButtonState>(
                                    bloc: imageUploadingButtonCubit,
                                    builder: (context, state) {
                                      if (state
                                          is ImageUploadingButtonInitial) {
                                        return GestureDetector(
                                          onTap: () {
                                            imageUploadingButtonCubit
                                                .uploadAndSaveImage();
                                          },
                                          child: Container(
                                            child: Text("select Imge"),
                                          ),
                                        );
                                      } else if (state
                                          is ImageUploadingButtonLoading) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state
                                          is ImageUploadingButtonSuccess) {
                                        return Container(
                                          child: Text("image upload success"),
                                        );
                                      } else if (state
                                          is ImageUploadingButtonFailed) {
                                        return Container(
                                          child: Text(state.error),
                                        );
                                      } else {
                                        return Container(
                                          child: Text("false"),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                        labelText: 'Category Name'),
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter a category name'
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                    onPressed: () => _addCategory(context),
                                    child: Text('Add')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return ListTile(
                            title: Text(category.name),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SubcategoryPage(categoryId: category.id)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is CategoryFail) {
                return Text("Failed");
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
