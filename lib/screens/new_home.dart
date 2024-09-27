import 'package:accomodation_app/screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';


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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
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
        _legendItem(Colors.green.shade300, 'Vacant'),
        const SizedBox(width: 16),
        _legendItem(Colors.orange.shade300, 'Booked'),
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'HSM Accommodation',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
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

                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));
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
            ],
          ),
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
    );
  }

  Widget _buildChoiceChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 7),
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
                  color: Colors.deepOrangeAccent,
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
                  color: Colors.deepOrangeAccent,
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
                  color: Colors.deepOrangeAccent,
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
              color: Colors.deepOrangeAccent,
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
                        SizedBox(width: 10),
                        Expanded(child: _buildBedGroup(filteredBedStatus.sublist(4, 9), 4, 2)),
                      ],
                    ),
                  ),
                  SizedBox(height: 3),
                ],
                if (selectedFilter != 'Girls') ...[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildBedGroup(filteredBedStatus.sublist(0, 4), 9, 3)),
                        SizedBox(width: 10),
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

      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              blurStyle: BlurStyle.normal,
              offset: Offset(5, 5),
            ),
            BoxShadow(
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

      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width / 3,
      margin: EdgeInsets.all(8),
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
                  childAspectRatio: 2.4,
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
          color: Colors.deepOrangeAccent,
        ),
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: const Icon(
          Icons.chevron_left,
          color: Colors.deepOrangeAccent,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right,
          color: Colors.deepOrangeAccent,
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
          color: Colors.orange.shade400,
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.deepOrange,
          shape: BoxShape.circle,
        ),
      ),
      enabledDayPredicate: (day) {
        return day.isAfter(DateTime.now()) || isSameDay(day, DateTime.now());
      },
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // Reverse the condition to show the correct dialog
          content: bedState == BedState.vacant
              ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Booking Details:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
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
            if (bedState == BedState.vacant) ...[
              TextButton(
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
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    bedStatusByDate[selectedDate]![index] = BedState.vacant;
                    bedDetailsByIndex.remove(index);
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Vacant',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade400,
                  ),
                ),
              ),
            ],
            if (bedState == BedState.booked)
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  int? bookedIndex = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEmployeeScreen(bedIndex: index),
                    ),
                  );
                  if (bookedIndex != null) {
                    setState(() {
                      bedStatusByDate[selectedDate]![bookedIndex] =
                          BedState.booked;
                    });
                  }
                },
                child: Text(
                  'Book',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
            TextButton(
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


  void _showConfirmationDialog(BuildContext context, int index,
      BedDetails bedDetails, DateTime newEndDate) {
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
            'Do you want to extend the end date to ${DateFormat('yyyy-MM-dd')
                .format(newEndDate)}?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  bedDetails.endDate =
                      DateFormat('yyyy-MM-dd').format(newEndDate);
                });
                Navigator.of(context).pop();
                _showBedDialog(index, BedState.booked);
              },
              child: Text(
                'Yes',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                ),
              ),
            ),
            TextButton(
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
            dialogBackgroundColor: Colors.orange,
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrangeAccent,
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
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    return pickedDate;
  }

  void _initializeBedStatus() {
    for (int i = 0; i < 30; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      if (!bedStatusByDate.containsKey(date)) {
        bedStatusByDate[date] = List.filled(18, BedState.vacant);

        // Randomly book a few beds
        for (int j = 0; j < 5; j++) { // Randomly booking 5 beds
          int bookedIndex = Random().nextInt(18);
          bedStatusByDate[date]![bookedIndex] = BedState.booked;

          // Initialize bed details for booked beds
          bedDetailsByIndex[bookedIndex] = BedDetails(
            roomNumber: 'Room ${bookedIndex + 100}',
            employeeName: 'Employee ${bookedIndex + 1}',
            department: 'Dept ${bookedIndex % 5}',
            startDate: DateFormat('yyyy-MM-dd').format(
                date.subtract(const Duration(days: 5))),
            endDate: DateFormat('yyyy-MM-dd').format(
                date.add(const Duration(days: 5))),
          );
        }
      }
    }
  }

}

// i want  that romm no go from 1 to 4 , count incse till 4 and ther eis an isuue that grid view f=grip show bottom overflowed 18
// only work on that do not chage any other thing