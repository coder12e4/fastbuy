import 'package:fastbuy/admin/cubit/addProducts/subCategoryCubit/subcategory_cubit.dart';
import 'package:fastbuy/admin/cubit/imageUploadButton/image_uploading_button_cubit.dart';
import 'package:fastbuy/admin/pages/products/productPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/emptyoralert.dart';
import '../../adminModels/addProductModel/addproduct.dart';
import '../../cubit/auth_cubit.dart';

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
      String? userid = await context.read<AuthCubit>().getUserId();
      final subcategory = Subcategory(
          id: userid!,
          name: _nameController.text,
          categoryId: widget.categoryId,
          userId: userid,
          image: subCategoryImage);
      context.read<SubcategoryCubit>().addSubcategory(subcategory);
      _nameController.clear();
    }
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
    context.read<SubcategoryCubit>().fetchSubcategories(widget.categoryId);

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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                                  Text("Add New")
                                ],
                              )),
                        )
                      ],
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
                                return Center(
                                  child: LinearProgressIndicator(
                                    value: state.prograss,
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
