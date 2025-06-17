import 'package:clozet/widgets/price_widget.dart';
import 'package:flutter/material.dart';

import '../utils/constants/textstyle.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productID;
  const ProductDetailsScreen({super.key, required this.productID});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  List<String> images = [
    'https://crazymonk.in/cdn/shop/files/FireFistAce_2.jpg?v=1746190552&width=360',
    'https://crazymonk.in/cdn/shop/files/WarriorofLiberation_1_3e393d6d-3581-46f3-9d5c-378059c57272.jpg?v=1746189955&width=360',
    'https://crazymonk.in/cdn/shop/files/FireFistAce_2.jpg?v=1746190552&width=360',
    'https://crazymonk.in/cdn/shop/files/WarriorofLiberation_1_3e393d6d-3581-46f3-9d5c-378059c57272.jpg?v=1746189955&width=360'
  ];

  int _currentIdx = 0;
  int _selectedSz = 0;
  int _quantity = 0;

  List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // image
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          images[_currentIdx],
                          width: mq.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // sub-images
                  Positioned(
                    right: 30,
                    top: 40,
                    child: SizedBox(
                      height: (100 * images.length).toDouble(),
                      width: 75,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: images.length < 3 ? images.length : 3,
                        itemBuilder: (context, index) {
                          bool isLastWithExtra =
                              (index == 2) && (images.length > 3);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIdx = index;
                              });
                            },
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        images[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    if (isLastWithExtra)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    if (isLastWithExtra)
                                      Center(
                                        child: Text(
                                          '+${images.length - 3}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    top: 30,
                    left: 30,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                        radius: 27,
                        backgroundColor: Color(0xffc2c2c2),
                        child: Icon(Icons.arrow_back_ios, size: 25),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Product Name",
                  style: TextStyleConst().headingStyle(
                    color: Colors.black,
                    size: 45,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // rating
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xff131b1e),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                "4.2",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Text("Ratings")
                    ],
                  ),

                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.grey,
                  ),

                  // reviews
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text("1.5K+ Reviews"),
                  ),

                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.grey,
                  ),
                  // Sold
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text("3.4K Sold"),
                  ),
                ],
              ),
              priceWidget(price: 1000, discount: 99),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,",
                  style: TextStyleConst().headingStyle(
                    color: Colors.grey,
                    size: 16,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: sizes.map((size) {
                  final idx = sizes.indexOf(size);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSz = idx;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: idx == _selectedSz
                            ? const Color(0xff131b1e)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffc2c2c2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            color: idx == _selectedSz
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                width: mq.width,
                height: mq.height * 0.08,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff131b1e),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xffc2c2c2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          height: mq.height * 7,
                          margin: const EdgeInsets.all(7),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xff1c282e),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                      scale: animation, child: child);
                                  // You can also try: FadeTransition(opacity: animation, child: child);
                                },
                                child: Text(
                                  '$_quantity',
                                  key: ValueKey<int>(
                                      _quantity), // This is important for AnimatedSwitcher to know the value changed
                                  style: TextStyleConst().headingStyle(
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _quantity--;
                                  });
                                },
                                icon: const Icon(Icons.remove,
                                    color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Container(
                        height: mq.height * 7,
                        margin: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            "Add to Cart",
                            style: TextStyleConst().headingStyle(
                              color: Colors.black,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
