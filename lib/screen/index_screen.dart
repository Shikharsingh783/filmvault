import 'package:filmvault/screen/home_screen.dart';
import 'package:filmvault/screen/search_screen.dart';
import 'package:filmvault/screen/wishList_screen.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/services.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  // Index for screen
  int _screenIndex = 0;

  // List of two screens: Home and Search
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => _onTabTapped(0),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedHome09,
                      color: _screenIndex == 0
                          ? Colors.white
                          : Colors.grey
                              .shade700, // White for active, grey for inactive
                      size: 30, // Slightly larger icon size
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onTabTapped(1),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch02,
                      color: _screenIndex == 1
                          ? Colors.white
                          : Colors.grey
                              .shade700, // White for active, grey for inactive
                      size: 30, // Slightly larger icon size
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onTabTapped(2),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedFavourite,
                      color: _screenIndex == 2
                          ? Colors.white
                          : Colors.grey
                              .shade700, // White for active, grey for inactive
                      size: 30, // Slightly larger icon size
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
