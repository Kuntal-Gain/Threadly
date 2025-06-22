import 'package:clozet/views/utils/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/users.dart';
import '../widgets/ad_widget.dart';
import 'product_screen.dart';

class FeedScreen extends StatefulWidget {
  final UserModel? user;
  const FeedScreen({super.key, this.user});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<String> categories = [
    'All',
    'Men',
    'Women',
    'T-Shirts',
    'Hoodies',
    'Accessories',
    'Trending',
  ];

  int _currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xffc2c2c2),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: GoogleFonts.firaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            widget.user?.name ?? "Guest",
                            style: TextStyleConst().headingStyle(
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              adWidget(
                label: 'Get Your Special\nSale upto ',
                imageUrl: 'assets/ads-1.png',
                discount: 50,
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIdx = categories.indexOf(category);
                              });
                            },
                            child: Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color:
                                    _currentIdx != categories.indexOf(category)
                                        ? Colors.white
                                        : const Color(0xff1a1f22),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  style: TextStyleConst().regularStyle(
                                    color: _currentIdx !=
                                            categories.indexOf(category)
                                        ? Colors.black
                                        : Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ));
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // Product grid
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductDetailsScreen(
                              productID: 'productID',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  'https://crazymonk.in/cdn/shop/files/CMVersity_1_CM.jpg?v=1749447196&width=713',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Product Name',
                                  style: TextStyleConst().headingStyle(
                                    color: Colors.black,
                                    size: 25,
                                  )),
                              Text('\$100',
                                  style: TextStyleConst().headingStyle(
                                    color: Colors.black,
                                    size: 25,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
