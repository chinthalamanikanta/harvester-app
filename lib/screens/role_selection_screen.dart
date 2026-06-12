import 'package:flutter/material.dart';
import 'farmer_home_screen.dart';
import 'owner_dashboard_screen.dart';
import 'farmer_main_screen.dart';


class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Role"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FarmerMainScreen(),
                    ),
                  );
                },
                child: const Text("Farmer"),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OwnerDashboardScreen(),
                    ),
                  );
                },
                child: const Text("Machine Owner"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}