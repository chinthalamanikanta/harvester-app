import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harvester_connect_mvp/screens/edit_owner_profile_screen.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerProfileScreen extends StatefulWidget {
  final int userId;

  const OwnerProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<OwnerProfileScreen> createState() =>
      _OwnerProfileScreenState();
}

class _OwnerProfileScreenState
    extends State<OwnerProfileScreen> {

  bool isLoading = true;

  String name = "";
  String phone = "";
  String role = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {

    final response = await http.get(
      Uri.parse(
        "http://127.0.0.1:8001/api/auth/user/${widget.userId}",
      ),
    );
    print("jjjoooo");
    print(response.body);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      setState(() {
        name = data["name"];
        phone = data["phone"];
        role = data["role"];
        isLoading = false;
        profileImage = data["profile_image"] ?? "";
        print("PROFILE IMAGE => $profileImage");
      });

    } else {

      setState(() {
        isLoading = false;
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
  title: const Text("Owner Profile"),
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
                EditOwnerProfileScreen(
              userId: widget.userId,
              name: name,
              phone: phone, profileImage: profileImage,
            ),
          ),
        );

        if (result == true) {
          await fetchProfile();
        }
      },
    ),
  ],
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

           CircleAvatar(
  radius: 55,
  backgroundColor: Colors.green,

  backgroundImage: profileImage.isNotEmpty
      ? NetworkImage(
          "http://127.0.0.1:8001/$profileImage?t=${DateTime.now().millisecondsSinceEpoch}",
        )
      : null,

  child: profileImage.isEmpty
      ? const Icon(
          Icons.person,
          size: 60,
          color: Colors.white,
        )
      : null,
),

            const SizedBox(height: 20),

            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                title: const Text("Name"),
                subtitle: Text(name),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.phone,
                  color: Colors.green,
                ),
                title: const Text("Mobile"),
                subtitle: Text(phone),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.badge,
                  color: Colors.green,
                ),
                title: const Text("Role"),
                subtitle: Text(role),
              ),
            ),
//             const SizedBox(height:30),
//             IconButton(
//   icon: const Icon(Icons.edit),
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => EditOwnerProfileScreen(
//           userId: widget.userId,
//           name: name,
//           phone: phone,
//         ),
//       ),
//     );
//   },
// ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),

                label: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
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