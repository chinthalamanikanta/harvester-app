import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harvester_connect_mvp/screens/edit_farmer_profile_screen.dart';
import 'package:harvester_connect_mvp/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FarmerProfileScreen extends StatefulWidget {
  final int userId;

  const FarmerProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<FarmerProfileScreen> createState() =>
      _FarmerProfileScreenState();
}

class _FarmerProfileScreenState
    extends State<FarmerProfileScreen> {

  bool isLoading = true;

  String name = "";
  String phone = "";
  String role = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    print("Farmer Profile User ID: ${widget.userId}");
    fetchProfile();
  }

  Future<void> fetchProfile() async {

    final response = await http.get(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/auth/user/${widget.userId}",
      ),
    );

    if (response.statusCode == 200) {
      print("hello");
      final data = jsonDecode(response.body);

      setState(() {
        name = data["name"];
        phone = data["phone"];
        role = data["role"];
        isLoading = false;
         profileImage =
      data["profile_image"] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
  title: const Text("Farmer Profile"),
  backgroundColor: Colors.green,

  actions: [
    IconButton(
      icon: const Icon(Icons.edit),

      onPressed: () async {

        final result =
            await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EditFarmerProfileScreen(
              userId: widget.userId,
              name: name,
              phone: phone,
              profileImage: profileImage,
            ),
          ),
        );

        if (result == true) {
          fetchProfile();
        }
      },
    ),
  ],
),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            CircleAvatar(
  radius: 55,

  backgroundImage:
      profileImage.isNotEmpty
          ? NetworkImage(
              "https://harvester-backend-5lcq.onrender.com/$profileImage?t=${DateTime.now().millisecondsSinceEpoch}",
            )
          : null,

  child: profileImage.isEmpty
      ? const Icon(
          Icons.person,
          size: 50,
        )
      : null,
),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Name"),
                subtitle: Text(name),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Mobile"),
                subtitle: Text(phone),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: const Text("Role"),
                subtitle: Text(role),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              // width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {

  final prefs =
      await SharedPreferences.getInstance();

  await prefs.clear();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const LoginScreen(),
    ),
    (route) => false,
  );
},
              ),
            ),
          ],
        ),
      ),
    );
  }
}