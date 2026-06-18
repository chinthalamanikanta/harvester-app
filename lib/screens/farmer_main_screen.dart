import 'package:flutter/material.dart';
import 'farmer_home_screen.dart';
import 'my_bookings_screen.dart';
import 'farmer_profile_screen.dart';

class FarmerMainScreen extends StatefulWidget {
  final int userId;
  const FarmerMainScreen({super.key, required this.userId,});

  @override
  State<FarmerMainScreen> createState() =>
      _FarmerMainScreenState();
}

class _FarmerMainScreenState
    extends State<FarmerMainScreen> {

  int selectedIndex = 0;

  late final List<Widget> screens;

@override
void initState() {
  super.initState();

  screens = [
    FarmerHomeScreen(
      userId: widget.userId,
    ),
    MyBookingsScreen(
      userId: widget.userId,
    ),
     FarmerProfileScreen(
      userId: widget.userId,
    ),
  ];
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Bookings",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}