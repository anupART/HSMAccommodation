//
//
// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
// import 'package:flutter/material.dart';
//
// import 'booking_page.dart';
// import 'history_page.dart';
// import 'new_home.dart';
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   final NotchBottomBarController _controller = NotchBottomBarController();
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     HSMAccommodation(),
//     const BookingPage(),
//     HistoryPage(),
//   ];
//
//   final List<Map<String, dynamic>> _bottomBarItemsData = [
//     {
//       'inactiveIcon': Icons.home_filled,
//       'activeIcon': Icons.home_outlined,
//       'label': 'Home',
//     },
//     {
//       'inactiveIcon': Icons.add_box,
//       'activeIcon': Icons.add_box_outlined,
//       'label': 'Booking',
//     },
//     {
//       'inactiveIcon': Icons.work_history,
//       'activeIcon': Icons.work_history_outlined,
//       'label': 'History',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: AnimatedNotchBottomBar(
//         notchBottomBarController: _controller,
//         kBottomRadius: 20.0,
//         kIconSize: 24.0,
//         onTap: (int value) {
//           setState(() {
//             _currentIndex = value;
//           });
//         },
//         durationInMilliSeconds: 400,
//         itemLabelStyle: const TextStyle(fontSize: 15, color: Colors.blueGrey),
//         elevation: 2.0,
//         bottomBarItems: _buildBottomBarItems(),
//       ),
//     );
//   }
//   List<BottomBarItem> _buildBottomBarItems() {
//     return _bottomBarItemsData.map((itemData) {
//       return BottomBarItem(
//         inActiveItem: Icon(
//           itemData['inactiveIcon'],
//           color: Colors.blueGrey,
//         ),
//         activeItem: Icon(
//           itemData['activeIcon'],
//           color: Colors.deepOrangeAccent,
//         ),
//         itemLabel: itemData['label'],
//       );
//     }).toList();
//   }
// }


import 'package:accomodation_app/screens/profilepage/profilepage.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bookingpage/booking_page.dart';
import '../historyscreen/history_page.dart';
import '../homescreen/new_home.dart';

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

  final List<String> _titles = [
    'Home Screen',
    'Booking',
    'History',
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _titles[_currentIndex],
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: _currentIndex == 0
            ? [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10, bottom: 3),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.orange.shade300,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                  },
                  icon: const Center(
                    child: Icon(
                      Icons.person,
                      size: 23,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]
            : null,
      ),
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