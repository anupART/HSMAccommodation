import 'package:accomodation_app/screens/bookingpage/booking_page.dart';
import 'package:accomodation_app/screens/profilepage/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';

import '../../style/color.dart';


Color _getBedColor(BedState state) {
  switch (state) {
    case BedState.vacant:
      return Colors.orange.shade300;
    case BedState.booked:
      return Colors.green.shade400;
    default:
      return Colors.white;
  }
}

Widget _detailItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _buildLegend() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 25,left: 16,right: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(bookedColor, 'Booked'),
        const SizedBox(width: 16),
        _legendItem(vacantColor, 'Vacant'),
      ],
    ),
  );
}

Widget _legendItem(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        color: color,
      ),
      const SizedBox(width: 8),
      Text(label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          )),
    ],
  );
}



enum BedState { vacant, booked }


class AddEmployeeScreen extends StatelessWidget {
  final int bedIndex;

  const AddEmployeeScreen({super.key, required this.bedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
        title: Text('Add Employee for Bed $bedIndex'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Employee Form'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, bedIndex);
              },
              child: const Text('Book'),
            ),
          ],
        ),
      ),
    );
  }
}


class BedDetails {
  final String roomNumber;
  final String employeeName;
  final String department;
  final String startDate;
  String endDate;

  BedDetails({
    required this.roomNumber,
    required this.employeeName,
    required this.department,
    required this.startDate,
    required this.endDate,
  });
}

void main() {
  runApp(MaterialApp(home: HSMAccommodation()));
}

class HSMAccommodation extends StatefulWidget {
  HSMAccommodation({this.index, super.key});

  int? index;

  @override
  _CalendarBedBookingState createState() => _CalendarBedBookingState();
}
class _CalendarBedBookingState extends State<HSMAccommodation> {
  late DateTime selectedDate;
  Map<DateTime, List<BedState>> bedStatusByDate = {};
  late DateTime focusedDate;
  Map<int, BedDetails> bedDetailsByIndex = {};
  String selectedFilter = 'All';
  List<BedState> _filteredBedStatus = [];
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    focusedDate = DateTime.now();
    _initializeBedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () {
          // This will dismiss the keyboard when tapping outside of a text field
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            // appBar: AppBar(
            //   backgroundColor: Colors.white,
            //   title: Text(
            //     'HSM Accommodation',
            //     style: GoogleFonts.poppins(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   actions: [
            //     Padding(
            //       padding: const EdgeInsets.only(right: 20, top: 10, bottom: 3),
            //       child: Container(
            //         width: 35,
            //         height: 35,
            //         decoration: BoxDecoration(
            //           color: Colors.orange.shade300,
            //           shape: BoxShape.circle,
            //         ),
            //         child: Center(
            //           child: IconButton(
            //             color: Colors.red,
            //
            //             onPressed: (){
            //               Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));
            //             },
            //             icon: const Center(
            //               child: Icon(
            //                 Icons.person,
            //                 size: 23,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            body: Column(
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.05,
                  child: Card(
                    elevation: 6,
                    color: Colors.white,
                    child: _buildTableCalendar(),
                  ),
                ),
                const SizedBox(height: 10),
                _buildChoiceChips(),
                const SizedBox(height: 5),
                Expanded(child: _buildBedLayout()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, top: 5, bottom: 2),
            child: ChoiceChip(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: selectedFilter == 'All' ? Colors.white : Colors.black,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              backgroundColor: Colors.white,
              label: Text(
                'All',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: myPrimaryColor,
                ),
              ),
              selected: selectedFilter == 'All',
              onSelected: (selected) {
                setState(() {
                  selectedFilter = 'All';
                });
              },
              selectedColor: Colors.white,
              labelStyle: TextStyle(
                color: selectedFilter == 'All' ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, top: 5, bottom: 2),
            child: ChoiceChip(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: selectedFilter == 'Girls' ? Colors.white : Colors.black,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              backgroundColor: Colors.white,
              label: Text(
                'Girls',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: myPrimaryColor,
                ),
              ),
              selected: selectedFilter == 'Girls',
              onSelected: (selected) {
                setState(() {
                  selectedFilter = 'Girls';
                });
              },
              selectedColor: selectedFilter == 'Girls' ? Colors.white : Colors.white,
              labelStyle: TextStyle(
                color: selectedFilter == 'Girls' ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, top: 5, bottom: 2),
            child: ChoiceChip(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: selectedFilter == 'Boys' ? Colors.white : Colors.black,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              backgroundColor: Colors.white,
              label: Text(
                'Boys',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: myPrimaryColor,
                ),
              ),
              selected: selectedFilter == 'Boys',
              onSelected: (selected) {
                setState(() {
                  selectedFilter = 'Boys';
                });
              },
              selectedColor: Colors.white,
              labelStyle: TextStyle(
                color: selectedFilter == 'Boys' ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomNumber(int roomNumber) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8,left: 8,right: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            decoration: BoxDecoration(
              color: myPrimaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Room $roomNumber',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<BedState> _getFilteredBedStatus(List<BedState> bedStatus) {
    if (selectedFilter == 'All') {
      return bedStatus;
    } else if (selectedFilter == 'Girls') {
      return bedStatus.sublist(0,9);
    } else if (selectedFilter == 'Boys') {
      return bedStatus.sublist(9,18);
    }
    return bedStatus;
  }

  Widget _buildBedLayout() {
    List<BedState> bedStatus = bedStatusByDate[selectedDate] ??
        List.generate(18, (index) => BedState.vacant);
    List<BedState> filteredBedStatus = _getFilteredBedStatus(bedStatus);

    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (selectedFilter != 'Boys') ...[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildBedGroup(filteredBedStatus.sublist(0, 4), 0, 1)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildBedGroup(filteredBedStatus.sublist(4, 9), 4, 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                if (selectedFilter != 'Girls') ...[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildBedGroup(filteredBedStatus.sublist(0, 4), 9, 3)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildBedGroup(filteredBedStatus.sublist(4, 9), 13, 4)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        _buildLegend(),
      ],
    );
  }

  Widget _buildBedGroup(List<BedState> groupBedStatus, int startIndex,int roomNumber) {
    return Container(
padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              blurStyle: BlurStyle.normal,
              offset: const Offset(5, 5),
            ),
            const BoxShadow(
              color: Colors.white,
              spreadRadius: 0,
              blurRadius: 10,
              blurStyle: BlurStyle.normal,
              offset: Offset(-5, -5),
            ),
          ],
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.black)
      ),

      height: MediaQuery.of(context).size.height / 5.3,
      width: MediaQuery.of(context).size.width / 3,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildRoomNumber(roomNumber),
          const SizedBox(height: 8,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing:8 ,
                ),
                itemCount: groupBedStatus.length,
                itemBuilder: (context, index) {
                  int bedIndex = startIndex + index;
                  return GestureDetector(
                    onTap: () => _showBedDialog(bedIndex, groupBedStatus[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getBedColor(groupBedStatus[index]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Bed ${bedIndex + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTableCalendar() {
    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      // firstDay: DateTime.now().subtract(const Duration(days: 365)),
      // lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: focusedDate,
      firstDay: DateTime.now().subtract(const Duration(days: 30)),
      lastDay: DateTime.now().add(const Duration(days: 60)),
      calendarFormat: CalendarFormat.week,
      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          selectedDate = selectedDay;
          focusedDate = focusedDay;
        });
      },
      headerStyle: HeaderStyle(
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: myPrimaryColor,
        ),
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: myPrimaryColor,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color:myPrimaryColor,
        ),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black,
        ),
        weekendTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        selectedTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        todayTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
        ),
        outsideTextStyle: GoogleFonts.poppins(
          color: Colors.grey.shade400,
        ),
        disabledTextStyle: GoogleFonts.poppins(
          color: Colors.grey.shade600,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: myPrimaryColor,
          shape: BoxShape.circle,
        ),
      ),
      // enabledDayPredicate: (day) {
      //   return day.isAfter(DateTime.now()) || isSameDay(day, DateTime.now());
      // },
      enabledDayPredicate: (day) => true,
    );
  }

  void _showBedDialog(int index, BedState bedState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Bed ${index + 1}',
            style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: bedState == BedState.booked
              ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Booking Details:',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              if (bedDetailsByIndex.containsKey(index)) ...[
                _detailItem('Room Number', bedDetailsByIndex[index]!.roomNumber),
                _detailItem('Employee Name', bedDetailsByIndex[index]!.employeeName),
                _detailItem('Department', bedDetailsByIndex[index]!.department),
                _detailItem('Start Date', bedDetailsByIndex[index]!.startDate),
                _detailItem('End Date', bedDetailsByIndex[index]!.endDate),
              ],
              const SizedBox(height: 10),
              Text(
                'Do you want to extend or vacate this bed?',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          )
              : Text(
            'Do you want to book this bed?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            if (bedState == BedState.booked) ...[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange.shade100),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  DateTime? newEndDate = await _selectEndDate(
                      context, bedDetailsByIndex[index]!.endDate);
                  if (newEndDate != null) {
                    _showConfirmationDialog(
                        context, index, bedDetailsByIndex[index]!, newEndDate);
                  }
                },
                child: Text(
                  'Extend',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: myPrimaryColor,
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green.shade100),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  _showVacateConfirmationDialog(context, index);
                },
                child: Text(
                  'Vacant',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: bookedColor,
                  ),
                ),
              ),
            ],
            if (bedState == BedState.vacant)
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange.shade100),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  dynamic result= await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage()

                    ),
                  );
                  if (result != null) {
                    setState(() {
                      bedStatusByDate[selectedDate]![index] = BedState.booked;
                      bedDetailsByIndex[index] = BedDetails(
                          roomNumber: result['roomNumber'],
                          employeeName: result['employeeName'],
                          department: result['department'],
                          startDate: DateFormat('yyyy-MM-dd').format(result['startDate']),
                      endDate: DateFormat('yyyy-MM-dd').format(result['endDate']),
                      );
                      List<BedState> bedStatus = bedStatusByDate[selectedDate] ??
                          List.generate(18, (index) => BedState.vacant);
                      List<BedState> filteredBedStatus = _getFilteredBedStatus(bedStatus);
                    });
                  }
                },
                child: Text(
                  'Book',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: myPrimaryColor,
                  ),
                ),
              ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black12),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, int index, BedDetails bedDetails, DateTime newEndDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Confirm Extension',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Do you want to extend the end date to ${DateFormat('yyyy-MM-dd').format(newEndDate)}?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black12),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  bedDetails.endDate = DateFormat('yyyy-MM-dd').format(newEndDate);
                  bedStatusByDate[selectedDate]![index] = BedState.booked;
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _showBedDialog(index, BedState.booked);
              },
              child: Text(
                'Yes',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: bookedColor,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black12),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  void _showVacateConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Confirm Vacate',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to vacate this bed?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black12),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  bedStatusByDate[selectedDate]![index] = BedState.vacant;
                  bedDetailsByIndex.remove(index);
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: bookedColor,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black12),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> _selectEndDate(BuildContext context,
      String currentEndDate) async {
    DateTime initialDate = DateFormat('yyyy-MM-dd').parse(currentEndDate);
    DateTime? pickedDate = await showDatePicker(
      builder: (context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Colors.orange.shade400,
              headerForegroundColor: Colors.white,
            ),
            dialogBackgroundColor: myOnSecondaryColor,
            colorScheme:  ColorScheme.light(
              primary: myPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    return pickedDate;
  }


  // void _initializeBedStatus() {
  //   for (int i = 0; i < 30; i++) {
  //     DateTime date = DateTime.now().add(Duration(days: i));
  //     if (!bedStatusByDate.containsKey(date)) {
  //       bedStatusByDate[date] = List.filled(18, BedState.vacant);
  //
  //       // Randomly book a few beds
  //       for (int j = 0; j < 5; j++) { // Randomly booking 5 beds
  //         int bookedIndex = Random().nextInt(18);
  //         bedStatusByDate[date]![bookedIndex] = BedState.booked;
  //
  //         // Initialize bed details for booked beds
  //         bedDetailsByIndex[bookedIndex] = BedDetails(
  //           roomNumber: 'Room ${bookedIndex + 100}',
  //           employeeName: 'Employee ${bookedIndex + 1}',
  //           department: 'Dept ${bookedIndex % 5}',
  //           startDate: DateFormat('yyyy-MM-dd').format(
  //               date.subtract(const Duration(days: 5))),
  //           endDate: DateFormat('yyyy-MM-dd').format(
  //               date.add(const Duration(days: 5))),
  //         );
  //       }
  //     }
  //   }
  // }
  void _initializeBedStatus() {
    // DateTime startDate = DateTime.now().subtract(const Duration(days: 365));
    // DateTime endDate = DateTime.now().add(const Duration(days: 30));
    DateTime startDate = DateTime.now().subtract(const Duration(days: 365));
    DateTime endDate = DateTime.now().add(const Duration(days: 365));
    for (DateTime date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      if (!bedStatusByDate.containsKey(date)) {
        bedStatusByDate[date] = List.filled(18, BedState.vacant);

        // Randomly book a few beds
        for (int j = 0; j < 5; j++) {
          int bookedIndex = Random().nextInt(18);
          bedStatusByDate[date]![bookedIndex] = BedState.booked;

          // Initialize bed details for booked beds
          bedDetailsByIndex[bookedIndex] = BedDetails(
            roomNumber: 'Room ${bookedIndex + 100}',
            employeeName: 'Employee ${bookedIndex + 1}',
            department: 'Dept ${bookedIndex % 5}',
            startDate: DateFormat('yyyy-MM-dd').format(date.subtract(const Duration(days: 5))),
            endDate: DateFormat('yyyy-MM-dd').format(date.add(const Duration(days: 5))),
          );
        }
      }
    }
  }
}

// why the data from booking page , after doing save booing showuld show in details dualog of an booked bed after clsikno on data of booking page for that partcvua;r bed ,
// convrsuion si happeing slow
//// so here i will go to the booking page and fill the deatils after that clicking on save booking we it will save te data and come back to home crseen by chnaging the clor of griid as it was doing currently
//                           // AddEmployeeScreen(bedIndex: index),

