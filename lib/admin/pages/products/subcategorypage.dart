import 'package:fastbuy/admin/pages/products/productPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../adminModels/addProductModel/addproduct.dart';
import '../../cubit/addProducts/subcategorycubit.dart';
import '../../cubit/auth_cubit.dart';

class SubcategoryPage extends StatelessWidget {
  final String categoryId;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  SubcategoryPage({required this.categoryId});

  void _addSubcategory(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String? userid = await context.read<AuthCubit>().getUserId();
      final subcategory = Subcategory(
          id: userid!,
          name: _nameController.text,
          categoryId: categoryId,
          userId: '');
      context.read<SubcategoryCubit>().addSubcategory(subcategory);
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<SubcategoryCubit>().fetchSubcategories(categoryId);

    return Scaffold(
      appBar: AppBar(title: Text('Subcategories')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration:
                          InputDecoration(labelText: 'Subcategory Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a subcategory name' : null,
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
          Expanded(
            child: BlocBuilder<SubcategoryCubit, List<Subcategory>>(
              builder: (context, subcategories) {
                if (subcategories.isEmpty) {
                  return Center(child: Text('No subcategories'));
                }
                return ListView.builder(
                  itemCount: subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = subcategories[index];

                    return ListTile(
                      title: Text(subcategory.name),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductPage(
                                categoryId: categoryId,
                                subcategoryId: subcategory.id)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
