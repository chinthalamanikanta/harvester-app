import 'package:flutter/material.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),

            SizedBox(height: 20),

            ListTile(
              title: Text("Name"),
              subtitle: Text("Ramesh"),
            ),

            ListTile(
              title: Text("Mobile"),
              subtitle: Text("9876543210"),
            ),

            ListTile(
              title: Text("District"),
              subtitle: Text("West Godavari"),
            ),
          ],
        ),
      ),
    );
  }
}