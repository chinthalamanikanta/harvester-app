import 'package:flutter/material.dart';
import 'owner_dashboard_screen.dart';
import 'owner_bookings_screen.dart';
import 'my_machines_screen.dart';
import 'owner_profile_screen.dart';

class OwnerMainScreen extends StatefulWidget {
  final int userId;

  const OwnerMainScreen({
    super.key,
    required this.userId,
  });

  @override
  State<OwnerMainScreen> createState() =>
      _OwnerMainScreenState();
}

class _OwnerMainScreenState
    extends State<OwnerMainScreen> {

  int selectedIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      OwnerDashboardScreen(
        userId: widget.userId,
      ),

      OwnerBookingsScreen(
        ownerId: widget.userId,
        userId: widget.userId,
      ),

      MyMachinesScreen(
        ownerId: widget.userId,
      ),

      OwnerProfileScreen(
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
  backgroundColor: Colors.green,

  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white70,

  type: BottomNavigationBarType.fixed,

  onTap: (index) {
    setState(() {
      selectedIndex = index;
    });
  },

  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: "Dashboard",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long),
      label: "Bookings",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.agriculture),
      label: "Machines",
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