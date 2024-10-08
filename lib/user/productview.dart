import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../admin/productlistprovider.dart';

class ProductView extends ConsumerStatefulWidget {
  const ProductView({super.key});
  @override
  ProductViewState createState() => ProductViewState();
}

class ProductViewState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(categoriesProvider);

    return SafeArea(
        child: Scaffold(
      body: cart.when(
          data: (data) => Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Product name",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart),
                                onPressed: () {
                                  /*      Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CartPage(),
                            ),
                          );        */
                                },
                              ),
                              Positioned(
                                top: 2,
                                right: -8,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red),
                                    child: Center(
                                      child: Text(
                                        "jjbb",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUkxiKQEI3TzkeV79In9QCV4HV7h22WA0CVQ&s",
                        width: 150,
                        height: 150,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: const TextSpan(
                      text: '',
                      children: <TextSpan>[
                        TextSpan(
                          text: '\$8.99',
                          style: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 8,
                              fontFamily: "semibold"),
                        ),
                        TextSpan(
                          text: ' \$3.99',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: "semibold"),
                        ),
                      ],
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          width: 180,
                          child: Expanded(
                            child: ListView.builder(
                                itemCount: data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, intex) {
                                  return Container(
                                    height: 40,
                                    width: 40,
                                    margin: const EdgeInsets.only(left: 4),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.blue, width: 1)),
                                    child: Image.network(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUkxiKQEI3TzkeV79In9QCV4HV7h22WA0CVQ&s",
                                      height: 30,
                                      width: 30,
                                    ),
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      height: 36,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, intx) {
                                  return Container(
                                    height: 20,
                                    width: 20,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.black)),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "+",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Divider(
                            height: 20,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          Text(
                            "0",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Divider(
                            height: 20,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          Text(
                            "-",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Discription",
                              style: Theme.of(context).textTheme.titleSmall,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Discription kjnvk jkndfvkjsdv jknfdkjdfvjbnkbdkvbb ubfbv blfbsvbdsjvb builbfbdsvubfsildubsdbvilubfv ubibfsl",
                                style: Theme.of(context).textTheme.bodyLarge,
                                maxLines: 8,
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Buy Now",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: const Icon(
                                Icons.add_shopping_cart_sharp,
                                size: 18,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          error: (e, s) => Center(
                child: Text("error"),
              ),
          loading: () => Center(
                child: CircularProgressIndicator(),
              )),
    ));
  }
}
