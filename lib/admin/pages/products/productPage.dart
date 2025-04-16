import 'dart:io';
import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/addProducts/productCubit/product_cubit.dart';
import '../../cubit/imageUploadButton/image_uploading_button_cubit.dart';

class ProductPage extends StatefulWidget {
  final String categoryId;
  final String subcategoryId;
  final String useId;

  ProductPage(
      {required this.categoryId,
      required this.subcategoryId,
      required this.useId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _priceController = TextEditingController();

  final _discountController = TextEditingController();

  final _stockController = TextEditingController();

  late ImageUploadingButtonCubit imageUploadingButtonCubit;

  late ProductCubit productCubit;

  String productImage = '';
  String selectedValue = 'Count';
  late File? _imageFile;
  double PriceAfterDiscount = 0.0;
  void _addProduct(BuildContext context) async {
    String? userId = widget.useId;
    if (_formKey.currentState!.validate() && productImage != '') {
      final product = Product(
          id: '',
          name: _nameController.text,
          price: double.parse(_priceController.text),
          categoryId: widget.categoryId,
          subcategoryId: widget.subcategoryId,
          userId: userId,
          image: productImage,
          Discount: _discountController.text,
          PriceAfterDiscount: PriceAfterDiscount.toString(),
          stock: int.parse(_stockController.text),
          QuantityType: selectedValue);

      context.read<ProductCubit>().addProduct(product);
      _nameController.clear();
      _priceController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please check all data that you added')));
    }
  }

  List<Product> productList = [];
  @override
  void initState() {
    // TODO: implement initState
    productCubit = ProductCubit();
    imageUploadingButtonCubit = ImageUploadingButtonCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Products')),
      body: BlocProvider<ProductCubit>(
        create: (context) => productCubit,
        child: BlocListener<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is ProductInitial) {
            } else if (state is statePiceAfterDiscount) {
              PriceAfterDiscount = state.PriceAfterDiscount;
              print(PriceAfterDiscount);
            } else if (state is ProductLoding) {
            } else if (state is ProductCreationSuccess) {
            } else if (state is ProductCreationFailed) {
            } else if (state is ProductsListLoding) {
            } else if (state is ProductsListSucess) {
              productList = state.product;
            } else if (state is ProductsListFail) {}
          },
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductInitial) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Add New Product",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
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
                                productCubit.fetchAll(widget.subcategoryId,
                                    widget.categoryId, widget.useId);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("list Products")
                                ],
                              )),
                        ),
                        SizedBox(
                          width: 16,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _nameController,
                              decoration:
                                  InputDecoration(labelText: 'Product Name'),
                              validator: (value) => value!.isEmpty
                                  ? 'Enter a product name'
                                  : null,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _priceController,
                              decoration:
                                  InputDecoration(labelText: 'Product Price'),
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty
                                  ? 'Enter a product price'
                                  : null,
                              onChanged: (value) {
                                productCubit.calculatePriceAfterDiscount(
                                    double.parse(_priceController.text),
                                    double.parse(_discountController.text));
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 60,
                                  child: TextFormField(
                                    controller: _discountController,
                                    decoration:
                                        InputDecoration(labelText: 'Discount'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter a product Discount'
                                        : null,
                                    onChanged: (value) {
                                      productCubit.calculatePriceAfterDiscount(
                                          double.parse(_priceController.text),
                                          double.parse(
                                              _discountController.text));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Price After Discount :$PriceAfterDiscount",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 60,
                                  child: TextFormField(
                                    controller: _stockController,
                                    decoration:
                                        InputDecoration(labelText: 'Stock'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter a product stock'
                                        : null,
                                    onChanged: (value) {
                                      productCubit.calculatePriceAfterDiscount(
                                          double.parse(_priceController.text),
                                          double.parse(
                                              _discountController.text));
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "Quantity Type",
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 4, right: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: Colors.black38)),
                                  child: Center(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedValue,
                                        hint: Text('Select an option'),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedValue = newValue!;
                                          });
                                        },
                                        items: ['Liter', 'Kg', 'Count']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                    productImage = state.imageUrl;
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
                                            SizedBox(
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
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Please enter category")));
                                                  } else {
                                                    imageUploadingButtonCubit
                                                        .showPicker(
                                                            context,
                                                            _nameController
                                                                .text);
                                                  }
                                                },
                                                child: Text("Select Image"))
                                          ],
                                        ),
                                      );
                                    } else if (state
                                        is ImageUploadingButtonLoading) {
                                      return SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Row(
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("${state.prograss}")
                                          ],
                                        ),
                                      );
                                    } else if (state
                                        is ImageUploadingButtonSuccess) {
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
                                                  if (_nameController
                                                      .text.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Please enter category")));
                                                  } else {
                                                    imageUploadingButtonCubit
                                                        .showPicker(
                                                            context,
                                                            _nameController
                                                                .text);
                                                  }
                                                },
                                                child: Text("Select Image"))
                                          ],
                                        ),
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
                            SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () => _addProduct(context),
                                        child: Text('Add Product')),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is statePiceAfterDiscount) {
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
                                productCubit.fetchAll(widget.subcategoryId,
                                    widget.categoryId, widget.useId);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("list Products")
                                ],
                              )),
                        ),
                        SizedBox(
                          width: 16,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Product Name'),
                              validator: (value) => value!.isEmpty
                                  ? 'Enter a product name'
                                  : null,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                  labelText: 'Product Price'),
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty
                                  ? 'Enter a product price'
                                  : null,
                              onChanged: (value) {
                                productCubit.calculatePriceAfterDiscount(
                                    double.parse(_priceController.text),
                                    double.parse(_discountController.text));
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 60,
                                  child: TextFormField(
                                    controller: _discountController,
                                    decoration:
                                        InputDecoration(labelText: 'Discount'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter a product Discount'
                                        : null,
                                    onChanged: (value) {
                                      productCubit.calculatePriceAfterDiscount(
                                          double.parse(_priceController.text),
                                          double.parse(
                                              _discountController.text));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Price After Discount :$PriceAfterDiscount",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: TextFormField(
                                    controller: _stockController,
                                    decoration:
                                        InputDecoration(labelText: 'Stock'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter a product stock'
                                        : null,
                                    onChanged: (value) {
                                      productCubit.calculatePriceAfterDiscount(
                                          double.parse(_priceController.text),
                                          double.parse(
                                              _discountController.text));
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: 140,
                                  height: 60,
                                  child: Center(
                                    child: DropdownButton<String>(
                                      value: selectedValue,
                                      hint: const Text('Select an option'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedValue = newValue!;
                                        });
                                      },
                                      items: ['Liter', 'Kg', 'Count']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
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
                                    productImage = state.imageUrl;
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
                                            SizedBox(
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
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Please enter category")));
                                                  } else {
                                                    imageUploadingButtonCubit
                                                        .showPicker(
                                                            context,
                                                            _nameController
                                                                .text);
                                                  }
                                                },
                                                child: Text("Select Image"))
                                          ],
                                        ),
                                      );
                                    } else if (state
                                        is ImageUploadingButtonLoading) {
                                      return SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Row(
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("${state.prograss}")
                                          ],
                                        ),
                                      );
                                    } else if (state
                                        is ImageUploadingButtonSuccess) {
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
                                                  if (_nameController
                                                      .text.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Please enter category")));
                                                  } else {
                                                    imageUploadingButtonCubit
                                                        .showPicker(
                                                            context,
                                                            _nameController
                                                                .text);
                                                  }
                                                },
                                                child: Text("Select Image"))
                                          ],
                                        ),
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
                            ElevatedButton(
                                onPressed: () => _addProduct(context),
                                child: Text('Add Product')),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is ProductLoding) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              } else if (state is ProductCreationSuccess) {
                return Column(
                  children: [
                    SizedBox(
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
                                productCubit.fetchAll(widget.subcategoryId,
                                    widget.categoryId, widget.useId);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("list Products")
                                ],
                              )),
                        ),
                        SizedBox(
                          width: 16,
                        )
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _nameController.text + " addedd Successfully",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        )
                      ],
                    ),
                    Expanded(child: SizedBox())
                  ],
                );
              } else if (state is ProductCreationFailed) {
                return Column(
                  children: [
                    SizedBox(
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
                                productCubit.MoveToInitial();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${_nameController.text} not added please try again",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        )
                      ],
                    ),
                  ],
                );
              } else if (state is ProductsListLoding) {
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              } else if (state is ProductsListSucess) {
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
                                productCubit.MoveToInitial();
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
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (context, intex) {
                              return Card(
                                child: ListTile(
                                  trailing: GestureDetector(
                                      onTap: () {
                                        productCubit.deleteProduct(
                                            widget.categoryId,
                                            widget.subcategoryId,
                                            "",
                                            productList[intex].id);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        size: 14,
                                        color: Colors.black,
                                      )),
                                  leading: Image.network(
                                    productList[intex].image,
                                    width: 100,
                                    height: 100,
                                  ),
                                  title: Text(
                                    productList[intex].name,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Price: \$${productList[intex].price}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                      Text(
                                          'Discount: ${productList[intex].Discount}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                      Text(
                                          'Price After Discount: \$${productList[intex].PriceAfterDiscount}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                );
              } else if (state is ProductCreationFailed) {}

              return Container();
            },
          ),
        ),
      ),
    );
  }
}
