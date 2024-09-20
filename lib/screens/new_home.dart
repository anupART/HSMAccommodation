import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(home: HSMAccommodation()));
}

class HSMAccommodation extends StatefulWidget {
   HSMAccommodation({this.index, super.key});

    int ? index;

  @override
  _CalendarBedBookingState createState() => _CalendarBedBookingState();
}

class _CalendarBedBookingState extends State<HSMAccommodation> {
  final CalendarWeekController _calendarController = CalendarWeekController();
  late DateTime selectedDate;
  Map<DateTime, List<BedState>> bedStatusByDate = {};

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'HSM Accommodation',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 20, bottom: 8),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 23,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(child: _buildBedLayout()),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: CalendarWeek(
        controller: _calendarController,
        height: 100,
        showMonth: true,
        minDate: DateTime.now().subtract(Duration(days: 30)),
        maxDate: DateTime.now().add(Duration(days: 60)),
        onDatePressed: (DateTime datetime) {
          setState(() {
            selectedDate = datetime;
          });
        },
        dayOfWeekStyle: const TextStyle(color: Colors.grey),
        dateStyle: const TextStyle(color: Colors.black),
        todayDateStyle: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBedLayout() {
    List<BedState> bedStatus = bedStatusByDate[selectedDate] ??
        List.generate(18, (index) => BedState.vacant);

    bool isPastDate = selectedDate.isBefore(DateTime.now());

    return Column(
      children: [
        SizedBox(height: 20),
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
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Bed ${index + 1}',
                      style: const TextStyle(color: Colors.white),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          title: Text('Bed ${index + 1}'),
          content: Text('Do you want to see details or cancel?'),
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
              child: Text('Details'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
          title: Text('Bed ${index + 1}'),
          content: bedState == BedState.booked
              ? Text('Do you want to see details or vacate the bed?')
              : Text('Do you want to book this bed?'),
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
                child: Text('Details'),
              ),
            if (bedState == BedState.booked)
              TextButton(
                onPressed: () {
                  setState(() {
                    bedStatusByDate[selectedDate]![index] = BedState.vacant;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Vacant'),
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
                  // Update the bed status only if successfully booked
                  if (bookedIndex != null) {
                    setState(() {
                      bedStatusByDate[selectedDate]![bookedIndex] =
                          BedState.booked;
                    });
                  }
                },
                child: Text('Book'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Color _getBedColor(BedState state) {
    switch (state) {
      case BedState.vacant:
        return Colors.grey.shade400;
      case BedState.booked:
        return Colors.orange.shade400;
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
          _legendItem(Colors.grey.shade400, 'Vacant'),
          _legendItem(Colors.orange.shade400, 'Booked'),
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
        SizedBox(width: 8),
        Text(label),
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
        title: Text('Add Employee'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigator
            // Navigator.pop(context, bedIndex);
          },
          child: Text('Book Bed'),
        ),
      ),
    );
  }
}
