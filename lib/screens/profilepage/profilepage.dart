import 'package:accomodation_app/screens/profilepage/change_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../loginscreen/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final TextEditingController _fullNameController =
  TextEditingController(text: "Anup Tarone");
  final TextEditingController _emailController =
  TextEditingController(text: "anuphsm@gmail.com");
  final TextEditingController _phoneNumberController =
  TextEditingController(text: "1234567890");
  final TextEditingController _addressController =
  TextEditingController(text: "Nowhere city Everywhere road");

  bool _isEditing = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style:  GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFFE5E5E5),
                  // backgroundImage: AssetImage('assets/profile.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Kshitija Bais',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'IT Intern',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            TextFormField(
              style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: "Full Name",
                labelStyle:   GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              readOnly: true,
              initialValue: "Anup Tarone",
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: "Email",
                labelStyle:   GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              readOnly: true,
              initialValue: "anuptarone22@gmail.com",
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: "Gender",
                labelStyle:   GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                prefixIcon: const Icon(Icons.person_2_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              readOnly: true,
              initialValue: "Male",
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: "Department",
                labelStyle:   GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                prefixIcon: const Icon(Icons.work),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              readOnly: true,
              initialValue: "Employee",
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: "Phone No.",
                labelStyle:   GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
              ),
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              readOnly: true,
              initialValue: "9090908989",
            ),
            const SizedBox(height: 16),
            CustomListTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePassword()));
              },

            ),
            const SizedBox(height: 24),
            CustomListTile(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: Colors.red,
              titleColor: Colors.red,
              onTap: () {
                Get.defaultDialog(
         backgroundColor: Colors.white,
                  buttonColor: Colors.orange.shade400,
                  title: 'Logout',
                  titleStyle:    GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                  middleText: 'Are you sure you want to log out?',
                  middleTextStyle:   GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                  textCancel: 'No',
                  textConfirm: 'Yes',
                  onConfirm: () {
                    Get.back(); // Close the dialog
                    Get.to(SignInScreen()); // Navigate to Login Page
                  },
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF5F6FA),
          child: Icon(icon, color: iconColor ?? Colors.orange),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: titleColor ?? Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}