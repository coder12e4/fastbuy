import 'dart:io';

import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/admin/cubit/category/category_cubit.dart';
import 'package:fastbuy/admin/cubit/imageUploadButton/image_uploading_button_cubit.dart';
import 'package:fastbuy/admin/pages/products/subcategorypage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';

class CategoryPage extends StatefulWidget {
  final String UserId;
  CategoryPage(this.UserId);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late String? categoryImage;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  List<Category> categories = [];
  late CategoryCubit categoryCubit;
  late ImageUploadingButtonCubit imageUploadingButtonCubit;
  late File? _imageFile;
  var isLoading;
  @override
  void initState() {
    categoryCubit = CategoryCubit();
    _imageFile = null;
    imageUploadingButtonCubit = ImageUploadingButtonCubit();
    categoryCubit.fetchCategories(widget.UserId);

    // TODO: implement initState
    super.initState();
  }

  void _addCategory(BuildContext context, String image, String? userId) async {
    if (_formKey.currentState!.validate()) {
      final category = Category(
          id: '', name: _nameController.text, userId: userId!, image: image);
      categoryCubit.addCategory(category, userId, image);
      _nameController.clear();
    }
  }

  final TextEditingController _searchController = TextEditingController();
  Widget Search() {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                //  adminCubit.loadProductsformSearch(value, userId);
                categoryCubit.loadCategoriesformSearch(value, widget.UserId);
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search',
              hintStyle: const TextStyle(fontSize: 14),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: FbColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: FbColors.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: FbColors.primaryColor),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: BlocProvider<CategoryCubit>(
          create: (context) => CategoryCubit(),
          child: BlocListener<CategoryCubit, CategoryState>(
            bloc: categoryCubit,
            listener: (context, state) {
              if (state is CategoryInitial) {
              } else if (state is CategoryLoading) {
              } else if (state is CategorySuccess) {
                categories = state.categories;
              } else if (state is CategorySearchFail) {
              } else if (state is CategoryFail) {}
            },
            child: BlocBuilder<CategoryCubit, CategoryState>(
              bloc: categoryCubit,
              builder: (context, state) {
                if (state is CategoryInitial) {
                  return Container();
                } else if (state is CategoryLoading) {
                  return Column(
                    children: [
                      Search(),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                } else if (state is CategorySuccess) {
                  return Column(
                    children: [
                      Search(),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Total Categories: ${categories.length}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 80,
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: () {
                                    categoryCubit.chageToAdd();
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "Add New",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return ListTile(
                              title: Text(category.name),
                              leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(category.image)),
                              subtitle: Text(category.id),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubcategoryPage(
                                          categoryId: category.id,
                                          userId: widget.UserId,
                                        )),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is CategoryFail) {
                  return Column(
                    children: [
                      Search(),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                } else if (state is CategorySearchFail) {
                  return Column(
                    children: [
                      Search(),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                } else if (state is CategoryAddInitial) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Add New Category",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      categoryCubit
                                          .fetchCategories(widget.UserId);
                                    },
                                    child: const SizedBox(
                                      width: 80,
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.list,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text("View List")
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          BlocProvider<ImageUploadingButtonCubit>(
                            create: (context) => ImageUploadingButtonCubit(),
                            child: BlocListener<ImageUploadingButtonCubit,
                                ImageUploadingButtonState>(
                              bloc: imageUploadingButtonCubit,
                              listener: (context, state) {
                                if (state is ImageUploadingButtonInitial) {
                                } else if (state
                                    is ImageUploadingButtonLoading) {
                                } else if (state
                                    is ImageUploadingButtonSuccess) {
                                  categoryImage = state.imageUrl;
                                } else if (state
                                    is ImageUploadingButtonFailed) {}
                              },
                              child: BlocBuilder<ImageUploadingButtonCubit,
                                  ImageUploadingButtonState>(
                                bloc: imageUploadingButtonCubit,
                                builder: (context, state) {
                                  if (state is ImageUploadingButtonInitial) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Center(
                                                  child: Icon(
                                                Icons.upload,
                                                size: 24,
                                                color: Colors.green,
                                              ))),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (_nameController
                                                    .text.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Please enter category")));
                                                } else {
                                                  imageUploadingButtonCubit
                                                      .showPicker(context,
                                                          _nameController.text);
                                                }
                                              },
                                              child: const Text("Select Image"))
                                        ],
                                      ),
                                    );
                                  } else if (state
                                      is ImageUploadingButtonLoading) {
                                    return Center(
                                      child: LinearProgressIndicator(
                                        value: state.prograss,
                                      ),
                                    );
                                  } else if (state
                                      is ImageUploadingButtonSuccess) {
                                    return Column(
                                      children: [
                                        Image.network(
                                          state.imageUrl,
                                          height: 100,
                                          width: 100,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (_nameController
                                                  .text.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Please enter category")));
                                              } else {
                                                imageUploadingButtonCubit
                                                    .showPicker(context,
                                                        _nameController.text);
                                              }
                                            },
                                            child: Text("Select Image"))
                                      ],
                                    );
                                  } else if (state
                                      is ImageUploadingButtonFailed) {
                                    return Text(state.error);
                                  } else {
                                    return const Text("false");
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                      labelText: 'Category Name'),
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter a category name'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                  onPressed: () => _addCategory(
                                      context, categoryImage!, widget.UserId),
                                  child: const Text('Add')),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else if (state is CategoryAddLoading) {
                  return Column(
                    children: [
                      Search(),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                } else if (state is CategoryAddSuccess) {
                  return Column(
                    children: [
                      Search(),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                } else if (state is CategoryAddFail) {
                  return Column(
                    children: [
                      Search(),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
