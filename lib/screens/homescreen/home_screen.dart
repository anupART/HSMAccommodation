// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   List<String> bookingStatus = List<String>.filled(10, "Booked");
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//
//     _tabController.addListener(() {
//       setState(() {}); // Update the UI
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         final double screenWidth = constraints.maxWidth;
//         final double screenHeight = constraints.maxHeight;
//         final double titleFontSize = screenWidth * 0.05;
//         final double subtitleFontSize = screenWidth * 0.04;
//         final double tabFontSize = screenWidth * 0.04;
//         final double iconSize = screenWidth * 0.06;
//         final double searchBarHeight = screenHeight * 0.06;
//         final double tabHeight = screenHeight * 0.05;
//
//         return Scaffold(
//           backgroundColor: Colors.white,
//           body: SafeArea(
//             child: Stack(children: [
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             right: 20, top: 20, bottom: 8),
//                         child: Container(
//                           width: iconSize,
//                           height: iconSize,
//                           decoration: BoxDecoration(
//                             color: muOnSecondaryColo,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.person,
//                             size: iconSize * 0.9,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Accommodations",
//                           style: GoogleFonts.roboto(
//                             fontSize: titleFontSize,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//                     child: Container(
//                       height: searchBarHeight,
//                       child: TextFormField(
//                         style: GoogleFonts.poppins(
//                           color: const Color(0xff020202),
//                           fontSize: subtitleFontSize,
//                           fontWeight: FontWeight.w400,
//                           letterSpacing: 0.5,
//                         ),
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: const Color(0xfff1f1f1),
//                           border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.circular(screenWidth * 0.02),
//                             borderSide: BorderSide.none,
//                           ),
//                           hintText: "Search",
//                           hintStyle: GoogleFonts.poppins(
//                             color: const Color(0xffb2b2b2),
//                             fontSize: subtitleFontSize,
//                             fontWeight: FontWeight.w400,
//                             letterSpacing: 0.5,
//                           ),
//                           prefixIcon: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Icon(Icons.search, size: iconSize * 0.7),
//                           ),
//                           prefixIconColor: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: screenWidth * 0.05),
//                       child: Text(
//                         "Category",
//                         style: GoogleFonts.roboto(
//                           fontSize: subtitleFontSize,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.01),
//                   TabBar(
//                     controller: _tabController,
//                     onTap: (index) {
//                       setState(() {}); // To trigger rebuild on tab change
//                     },
//                     padding:
//                         EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//                     labelPadding: EdgeInsets.zero,
//                     labelStyle: GoogleFonts.roboto(
//                       fontSize: tabFontSize,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     unselectedLabelColor: Colors.black,
//                     indicatorPadding: EdgeInsets.all(screenWidth * 0.005),
//                     indicator: BoxDecoration(
//                       borderRadius: BorderRadius.circular(screenWidth * 0.01),
//                       color: Colors.transparent,
//                     ),
//                     dividerColor: Colors.transparent,
//                     tabs: [
//                       _buildTab("All", 0, screenWidth, tabHeight),
//                       _buildTab("Girls", 1, screenWidth, tabHeight),
//                       _buildTab("Boys", 2, screenWidth, tabHeight),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   NotificationListener<ScrollNotification>(
//                     onNotification: (scrollNotification) {
//                       if (scrollNotification is ScrollEndNotification) {
//                         int currentIndex = _tabController.index;
//                         int newIndex = _tabController.animation!.value.round();
//                         if (currentIndex != newIndex) {
//                           setState(() {
//                             _tabController.index = newIndex;
//                           });
//                         }
//                       }
//                       return true;
//                     },
//                     child: Expanded(
//                       child: TabBarView(
//                         controller: _tabController,
//                         physics: PageScrollPhysics(),
//                         children: [
//                           _buildAllTabContent(screenWidth, screenHeight),
//                           _buildTabContent("Girls", screenWidth, screenHeight),
//                           _buildTabContent("Boys", screenWidth, screenHeight),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ]),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildAllTabContent(double screenWidth, double screenHeight) {
//     return ListView.builder(
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: screenHeight * 0.01,
//             horizontal: screenWidth * 0.05,
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(color: Colors.black),
//             ),
//             child: IntrinsicHeight(
//               child: Row(
//                 children: [
//                   _buildLeadingSection(screenWidth, screenHeight),
//                   _buildMiddleSection(screenWidth, screenHeight),
//                   _buildTrailingSection(index, screenWidth, screenHeight),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildLeadingSection(double screenWidth, double screenHeight) {
//     return Expanded(
//       flex: 2,
//       child: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.02),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: screenWidth * 0.12,
//               width: screenWidth * 0.12,
//               decoration: const BoxDecoration(
//                 color: Colors.orange,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   "01",
//                   style: GoogleFonts.roboto(
//                     fontSize: screenWidth * 0.04,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.005),
//             Text(
//               'Room No:- 1',
//               style: GoogleFonts.roboto(
//                 fontSize: screenWidth * 0.03,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMiddleSection(double screenWidth, double screenHeight) {
//     return Expanded(
//       flex: 4,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Name',
//               style: GoogleFonts.roboto(
//                 fontSize: screenWidth * 0.04,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.005),
//             Text(
//               '12-12-2024',
//               style: GoogleFonts.roboto(
//                 fontSize: screenWidth * 0.035,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTrailingSection(
//       int index, double screenWidth, double screenHeight) {
//     return Expanded(
//       flex: 2,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'Details') {
//                 print("Details selected");
//               } else if (value == 'Vacant') {
//                 _showVacantDialog(index);
//               }
//             },
//             itemBuilder: (BuildContext context) {
//               return [
//                 const PopupMenuItem(
//                   value: 'Details',
//                   child: Text('Details'),
//                 ),
//                 if (bookingStatus[index] != 'Vacant')
//                   const PopupMenuItem(
//                     value: 'Vacant',
//                     child: Text('Vacant'),
//                   ),
//               ];
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               height: MediaQuery.of(context).size.width / 13,
//               width: MediaQuery.of(context).size.width / 6,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: bookingStatus[index] == 'Vacant'
//                     ? Colors.red
//                     : Colors.green,
//               ),
//               padding: const EdgeInsets.all(5),
//               child: Center(
//                 child: Text(
//                   bookingStatus[index],
//                   style: GoogleFonts.roboto(
//                     fontSize: screenWidth * 0.035,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTab(
//       String title, int index, double screenWidth, double tabHeight) {
//     bool isSelected = _tabController.index == index;
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
//       padding: EdgeInsets.symmetric(vertical: tabHeight * 0.2),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.orange : Colors.grey,
//         borderRadius: BorderRadius.circular(screenWidth * 0.01),
//       ),
//       child: Center(
//         child: Text(
//           title,
//           style: GoogleFonts.roboto(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabContent(String tab, double screenWidth, double screenHeight) {
//     return Center(
//       child: Text(
//         "This is $tab tab",
//         style: GoogleFonts.roboto(
//           fontSize: screenWidth * 0.05,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   void _showVacantDialog(int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text(
//             'Confirm Vacant',
//             style: GoogleFonts.roboto(
//                 fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//           content: Text(
//             'Do you want to mark this bed as vacant?',
//             style: GoogleFonts.roboto(
//               fontSize: 14,
//               color: Colors.black,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(
//                 'Cancel',
//                 style: GoogleFonts.roboto(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   bookingStatus[index] = 'Vacant';
//                 });
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Confirm',
//                 style: GoogleFonts.roboto(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// // there is issue when i clcikn on tah , tabbarview chnages but when i swipe on side of  page the tha  tabbarview chnages but that tabs girls, boys indictaor orange color dosent ahneg it raemain only grey a it is befor as i wsir te indicayor color orage like imn showuld aslo travel from tabs to tabvs