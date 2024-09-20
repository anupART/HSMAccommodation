import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart'; // New import for TableCalendar
import 'dart:math';

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

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    focusedDate = DateTime.now();
    _initializeBedStatus();
  }

  void _initializeBedStatus() {
    for (int i = 0; i < 30; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      if (!bedStatusByDate.containsKey(date)) {
        bedStatusByDate[date] = List.generate(18,
                (index) => Random().nextBool() ? BedState.vacant : BedState.booked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              padding: const EdgeInsets.only(right: 20, top: 10, bottom: 8),
              child: Container(
                width: 35,
                height: 35,
                decoration:  BoxDecoration(
                  color: Colors.orange.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 23,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          // bottom: [
          //   PreferredSize(
          //       preferredSize: PreferredSize.height(100),
          //       child: _buildTableCalendar()),
          // ],
          /*
          *  bottom: PreferredSize(
      preferredSize: const Size.fromHeight(100), // Specify the size for your custom widget
      child: _buildTableCalendar(), // Use your custom calendar widget
        ),*/
        ),
        body: Column(
          children: [
            const SizedBox(height: 8,),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.05,
              child: Card(
                elevation: 6,
                  color: Colors.white,
                  child: _buildTableCalendar()),
            ),
            // Divider(color: Colors.grey.shade400,indent: 10,endIndent: 10,height: 0,thickness: 2,),
            SizedBox(height: 10,),
            Expanded(child: _buildBedLayout()),
          ],
        ),
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
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.deepOrange,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
    );
  }


  Widget _buildBedLayout() {
    List<BedState> bedStatus = bedStatusByDate[selectedDate] ?? List.generate(18, (index) => BedState.vacant);
    bool isPastDate = selectedDate.isBefore(DateTime.now());

    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: 18,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: isPastDate
                    ? () => _showCurrentDateDialog(index)
                    : () => _showFutureDateDialog(index, bedStatus[index]),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getBedColor(bedStatus[index]),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Bed ${index + 1}',
                      style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                    )
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
            style:  GoogleFonts.poppins(
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

  void _showCurrentDateDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Bed ${index + 1}',    style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),),
          content:  Text('Do you want to see details or cancel?', style: GoogleFonts.poppins(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
            color: Colors.black,
          )
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BedDetailsPage(bedIndex: index),
                  ),
                );
              },
              child: Text('Details',
              style:   GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',
                style:   GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                ),),
            ),
          ],
        );
      },
    );
  }

  void _showFutureDateDialog(int index, BedState bedState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Bed ${index + 1}',style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ) ,),
          content: bedState == BedState.booked
              ?  Text('Do you want to see details or vacate the bed?',style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
          )
          )
              :  Text('Do you want to book this bed?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ) ),
          actions: [
            if (bedState == BedState.booked)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BedDetailsPage(bedIndex: index),
                    ),
                  );
                },
                child:  Text('Details',style:  GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.deepOrangeAccent,
                )
                ),
              ),
            if (bedState == BedState.booked)
              TextButton(
                onPressed: () {
                  setState(() {
                    bedStatusByDate[selectedDate]![index] = BedState.vacant;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Vacant',
                    style:  GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade300,
                    )
                ),
              ),
            if (bedState == BedState.vacant)
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
                      bedStatusByDate[selectedDate]![bookedIndex] = BedState.booked;
                    });
                  }
                },
                child:  Text('Book',
                    style:  GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    )
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  Text('Cancel',
                  style:  GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade400,
                  )),
            ),
          ],
        );
      },
    );
  }

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

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(Colors.orange.shade300, 'Vacant'),
          _legendItem(Colors.green.shade400, 'Booked'),
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
        style:         GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.black,
    )),
      ],
    );
  }
}

enum BedState { vacant, booked }

class BedDetailsPage extends StatelessWidget {
  final int bedIndex;

  BedDetailsPage({super.key, required this.bedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bed $bedIndex Details'),
      ),
      body: Center(
        child: Text('Details for Bed $bedIndex'),
      ),
    );
  }
}

class AddEmployeeScreen extends StatelessWidget {
  final int bedIndex;

  AddEmployeeScreen({super.key, required this.bedIndex});

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