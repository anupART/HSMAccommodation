import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BedDetailsPage extends StatelessWidget {
  final int bedIndex;

  BedDetailsPage({super.key, required this.bedIndex});

  @override
  Widget build(BuildContext context) {
    // Sample data to show details. Replace with actual data from your API or model.
    String roomNumber = "Room 101";
    String employeeName = "John Doe";
    String department = "IT Department";
    String startDate = "2024-01-01";
    String endDate = "2024-12-31";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bed ${bedIndex + 1} Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem('Room Number', roomNumber),
            _detailItem('Employee Name', employeeName),
            _detailItem('Department', department),
            _detailItem('Start Date', startDate),
            _detailItem('End Date', endDate),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Vacate" button action
                  Navigator.of(context).pop(); // Pop back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Vacate',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display each detail
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
              overflow: TextOverflow.ellipsis, // If the text is too long
            ),
          ),
        ],
      ),
    );
  }
}
