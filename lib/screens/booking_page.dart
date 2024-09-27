import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bottom_nav_bar.dart';
import 'new_home.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _selectedGender;
  String? _selectedBedNo;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> genders = ['Female', 'Male'];
  final Map<String, List<String>> bedNumbers = {
    'Female': List.generate(9, (index) => 'Bed No. ${index + 1}'),
    'Male': List.generate(9, (index) => 'Bed No. ${index + 10}'),
  };

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        // leading: Navigator.pop(),
        // leading: IconButton(
        //   // Within the `FirstRoute` widget:
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => BottomNavBar()),
        //       );
        //     },
        //     icon:  Icon(Icons.arrow_back_ios,size: 23,)),
        // centerTitle: true,
        title: const Text(
          'Booking',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _buildDropdowns(),
              const SizedBox(height: 20),
              _buildTextField("Full Name", Icons.person, "Kshitija Bais"),
              const SizedBox(height: 20),
              _buildTextField("Email ID", Icons.email, "Kshitija@Bais"),
              const SizedBox(height: 20),
              _buildTextField("Department", Icons.account_balance, "IT"),
              const SizedBox(height: 20),
              _buildTextField("Designation", Icons.work, "Intern"),
              const SizedBox(height: 20),
              _buildTextField("Employee ID", Icons.badge, "123456"),
              const SizedBox(height: 20),
              _buildDatePickers(),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdowns() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              fillColor: const Color(0xFFF5F5F5),
              labelText: 'Gender',
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            value: _selectedGender,
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
                _selectedBedNo = null;
              });
            },
            items: genders.map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              fillColor: const Color(0xFFF5F5F5),
              labelText: 'Bed No.',
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            value: _selectedBedNo,
            onChanged: _selectedGender == null
                ? null
                : (String? newValue) {
              setState(() {
                _selectedBedNo = newValue;
              });
            },
            items: _selectedGender == null
                ? []
                : bedNumbers[_selectedGender]!.map((String bed) {
              return DropdownMenuItem<String>(
                value: bed,
                child: Text(bed),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon, String initialValue) {
    return TextFormField(
      decoration: InputDecoration(
        fillColor:const Color(0xFFF5F5F5),
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      readOnly: true,
      initialValue: initialValue,
    );
  }

  Widget _buildDatePickers() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectStartDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_today),
                  labelText: 'Start Date',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                controller: TextEditingController(
                  text: formatDate(_startDate),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Text('To', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectEndDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_today),
                  labelText: 'End Date',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                controller: TextEditingController(
                  text: formatDate(_endDate),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Save action
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.deepOrange,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: const Text(
          'Save Booking',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

