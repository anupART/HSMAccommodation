

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'booking_page.dart';
import 'history_page.dart';
import 'new_home.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final NotchBottomBarController _controller = NotchBottomBarController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HSMAccommodation(),
    const BookingPage(),
    HistoryPage(),
  ];

  final List<Map<String, dynamic>> _bottomBarItemsData = [
    {
      'inactiveIcon': Icons.home_filled,
      'activeIcon': Icons.home_outlined,
      'label': 'Home',
    },
    {
      'inactiveIcon': Icons.add_box,
      'activeIcon': Icons.add_box_outlined,
      'label': 'Booking',
    },
    {
      'inactiveIcon': Icons.work_history,
      'activeIcon': Icons.work_history_outlined,
      'label': 'History',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        kBottomRadius: 20.0,
        kIconSize: 24.0,
        onTap: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
        durationInMilliSeconds: 400,
        itemLabelStyle: const TextStyle(fontSize: 15, color: Colors.blueGrey),
        elevation: 2.0,
        bottomBarItems: _buildBottomBarItems(),
      ),
    );
  }
  List<BottomBarItem> _buildBottomBarItems() {
    return _bottomBarItemsData.map((itemData) {
      return BottomBarItem(
        inActiveItem: Icon(
          itemData['inactiveIcon'],
          color: Colors.blueGrey,
        ),
        activeItem: Icon(
          itemData['activeIcon'],
          color: Colors.deepOrangeAccent,
        ),
        itemLabel: itemData['label'],
      );
    }).toList();
  }
}