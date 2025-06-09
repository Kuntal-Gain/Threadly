import 'package:clozet/utils/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/ad_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xffc2c2c2),
                  ),
                  SizedBox(
                    width: 10,
                  ),
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
                          'Guest',
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
            SizedBox(
              height: 50,
            ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: _currentIdx != categories.indexOf(category)
                                  ? Colors.white
                                  : Color(0xff1a1f22),
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

            // products

            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 3,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Image.network(
                            'https://via.placeholder.com/150',
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          Text('Product Name'),
                          Text('Product Price'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
