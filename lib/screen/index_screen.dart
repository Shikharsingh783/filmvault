import 'package:filmvault/screen/home_screen.dart';
import 'package:filmvault/screen/search_screen.dart';
import 'package:filmvault/screen/wishList_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  // Index for screen
  int _screenIndex = 0;

  // List of three screens: Home, Search, and Wishlist
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    WishlistScreen()
  ];

  // Handle bottom navigation tap
  void _onTabTapped(int index) {
    setState(() {
      _screenIndex = index; // Update the selected screen index
    });
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Display the current screen
          _screens[_screenIndex],
          // Custom bottom navigation bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade900, // Dark background
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Icon + Label
                  GestureDetector(
                    onTap: () => _onTabTapped(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.home,
                          color: _screenIndex == 0 ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: _screenIndex == 0 ? Colors.red : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Icon + Label
                  GestureDetector(
                    onTap: () => _onTabTapped(1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search,
                          color: _screenIndex == 1 ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Search',
                          style: TextStyle(
                            color: _screenIndex == 1 ? Colors.red : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Wishlist Icon (Center, Larger Icon)
                  GestureDetector(
                    onTap: () => _onTabTapped(2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: _screenIndex == 2 ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Wishlist',
                          style: TextStyle(
                            color: _screenIndex == 2 ? Colors.red : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
