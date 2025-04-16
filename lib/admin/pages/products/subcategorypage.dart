import 'package:fastbuy/admin/cubit/addProducts/subCategoryCubit/subcategory_cubit.dart';
import 'package:fastbuy/admin/cubit/imageUploadButton/image_uploading_button_cubit.dart';
import 'package:fastbuy/admin/pages/products/productPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/emptyoralert.dart';
import '../../adminModels/addProductModel/addproduct.dart';

class SubcategoryPage extends StatefulWidget {
  final String categoryId;
  final String userId;

  SubcategoryPage({super.key, required this.categoryId, required this.userId});

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  String subCategoryImage = '';

  late ImageUploadingButtonCubit imageUploadingButtonCubit;
  late SubcategoryCubit subcategoryCubit;

  List<Subcategory> subcategories = [];
  void _addSubcategory(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String? userid = widget.userId;
      final subcategory = Subcategory(
          id: userid,
          name: _nameController.text,
          categoryId: widget.categoryId,
          userId: userid,
          image: subCategoryImage);
      subcategoryCubit.addSubcategory(subcategory);
      _nameController.clear();
    }
  }

  final TextEditingController _searchController = TextEditingController();
  Widget Search() {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            style: TextStyle(fontSize: 14, color: Colors.black),
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                //  adminCubit.loadProductsformSearch(value, userId);
                subcategoryCubit.loadCategoriesformSearch(value, widget.userId);
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
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    subcategoryCubit = SubcategoryCubit();
    subcategoryCubit.fetchSubcategories(widget.categoryId);
    imageUploadingButtonCubit = ImageUploadingButtonCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subcategories')),
      body: BlocProvider<SubcategoryCubit>(
        create: (context) => subcategoryCubit,
        child: BlocListener<SubcategoryCubit, SubcategoryState>(
          listener: (context, state) {
            if (state is SubcategoryInitial) {
            } else if (state is SubcategoryListLoading) {
            } else if (state is SubcategoryListSuccess) {
              subcategories = state.subcategories;
            } else if (state is SubcategoryAddNewSubcategoryInitial) {
            } else if (state is SubcategoryAddNewSubcategorySuccess) {
            } else if (state is SubcategoryAddNewSubcategoryFail) {}
          },
          child: BlocBuilder<SubcategoryCubit, SubcategoryState>(
            builder: (context, state) {
              if (state is SubcategoryInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SubcategoryListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SubcategoryListSuccess) {
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
                            "Total Categories: ${subcategories.length}",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 80,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: () {
                                  subcategoryCubit.addSubcategories();
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "Add New",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: subcategories.length,
                      itemBuilder: (context, index) {
                        final subcategory = subcategories[index];

                        if (subcategories.isEmpty) {
                          return const EmptyOrAlert(
                            empty: true,
                          );
                        } else {
                          return ListTile(
                            leading: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.network(subcategory.image)),
                            title: Text(subcategory.name),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                        categoryId: widget.categoryId,
                                        subcategoryId: subcategory.id,
                                        useId: widget.userId,
                                      )),
                            ),
                          );
                        }
                      },
                    ))
                  ],
                );
              } else if (state is SubcategoryAddNewSubcategoryInitial) {
                return Column(
                  children: [
                    Container(
                      child: BlocProvider<ImageUploadingButtonCubit>(
                        create: (context) => ImageUploadingButtonCubit(),
                        child: BlocListener<ImageUploadingButtonCubit,
                            ImageUploadingButtonState>(
                          bloc: imageUploadingButtonCubit,
                          listener: (context, state) {
                            if (state is ImageUploadingButtonInitial) {
                            } else if (state is ImageUploadingButtonLoading) {
                            } else if (state is ImageUploadingButtonSuccess) {
                              subCategoryImage = state.imageUrl;
                            } else if (state is ImageUploadingButtonFailed) {}
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
                                            if (_nameController.text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Please enter Sub category")));
                                            } else {
                                              imageUploadingButtonCubit
                                                  .showPicker(context,
                                                      _nameController.text);
                                            }
                                          },
                                          child: Text("Select Image"))
                                    ],
                                  ),
                                );
                              } else if (state is ImageUploadingButtonLoading) {
                                return const Center(
                                  child: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text("Uploading")
                                    ],
                                  ),
                                );
                              } else if (state is ImageUploadingButtonSuccess) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        state.imageUrl,
                                        height: 100,
                                        width: 100,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            if (_nameController.text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Please enter Subcategory")));
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
                              } else if (state is ImageUploadingButtonFailed) {
                                return Text(state.error);
                              } else {
                                return const Text("false");
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                    labelText: 'Subcategory Name'),
                                validator: (value) => value!.isEmpty
                                    ? 'Enter a subcategory name'
                                    : null,
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                                onPressed: () => _addSubcategory(context),
                                child: Text('Add')),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is SubcategoryAddNewSubcategorySuccess) {
                return SizedBox();
              } else if (state is SubcategoryAddNewSubcategoryFail) {
                return SizedBox();
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
