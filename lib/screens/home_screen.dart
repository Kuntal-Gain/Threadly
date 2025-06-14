import 'package:clozet/screens/feed_screen.dart';
import 'package:flutter/material.dart';

import '../utils/widgets/nav_icons.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _screens = [];

  int _currentIdx = 0;

  void _onTap(int idx) {
    setState(() {
      _currentIdx = idx;
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      FeedScreen(),
      SearchScreen(),
      Container(
        child: Center(
          child: Text("Bag"),
        ),
      ),
      Container(
        child: Center(
          child: Text("User"),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIdx],
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xff121a1c),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navIcon(
              icon: "assets/icons/home.png",
              isSelected: _currentIdx == 0,
              onTap: () => _onTap(0),
            ),
            navIcon(
              icon: "assets/icons/search.png",
              isSelected: _currentIdx == 1,
              onTap: () => _onTap(1),
            ),
            navIcon(
              icon: "assets/icons/market.png",
              isSelected: _currentIdx == 2,
              onTap: () => _onTap(2),
            ),
            navIcon(
                icon: "assets/icons/user.png",
                isSelected: _currentIdx == 3,
                onTap: () => _onTap(3)),
          ],
        ),
      ),
    );
  }
}
