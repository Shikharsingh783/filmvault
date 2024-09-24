import 'package:filmvault/screen/home_screen.dart';
import 'package:filmvault/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

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
  ];

  // Handle bottom navigation tap
  void _onTabTapped(int index) {
    setState(() {
      _screenIndex = index; // Update the selected screen index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_screenIndex], // Display the current screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Keep icons fixed
        showSelectedLabels: false, // Hide labels like in iOS
        showUnselectedLabels: false, // Hide unselected labels
        currentIndex: _screenIndex, // Track the current selected screen
        onTap: _onTabTapped, // Handle tab tap
        backgroundColor: Colors.black, // Dark background for dark mode
        elevation: 5, // Subtle elevation for a sleek look
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome09,
              color: _screenIndex == 0
                  ? Colors.white
                  : Colors.grey.shade700, // White for active, grey for inactive
              size: 22, // Smaller icon size for a minimal look
            ),
            label: 'Home', // Required but hidden
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch02,
              color: _screenIndex == 1
                  ? Colors.white
                  : Colors.grey.shade700, // White for active, grey for inactive
              size: 22, // Smaller icon size for a minimal look
            ),
            label: 'Search', // Required but hidden
          ),
        ],
      ),
    );
  }
}
