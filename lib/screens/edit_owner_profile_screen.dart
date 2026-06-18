import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditOwnerProfileScreen extends StatefulWidget {
  final int userId;
  final String name;
  final String phone;
  final String profileImage;

  const EditOwnerProfileScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.phone,
    required this.profileImage,
  });

  @override
  State<EditOwnerProfileScreen> createState() =>
      _EditOwnerProfileScreenState();
}

class _EditOwnerProfileScreenState
    extends State<EditOwnerProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  bool isLoading = false;

  File? selectedImage;
  late String profileImage;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.name);

    phoneController =
        TextEditingController(text: widget.phone);

    profileImage = widget.profileImage;
  }

  Future<void> pickImage() async {
    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> uploadImage() async {
     print("UPLOAD IMAGE CALLED");
    if (selectedImage == null) return;

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "http://127.0.0.1:8001/api/auth/upload-profile/${widget.userId}",
      ),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        selectedImage!.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData =
          await response.stream.bytesToString();

      final data = jsonDecode(responseData);

      setState(() {
        profileImage =
            data["profile_image"] ?? profileImage;
      });
    }
  }

  Future<void> updateProfile() async {

  setState(() {
    isLoading = true;
  });

  await uploadImage();

  final response = await http.put(
    Uri.parse(
      "http://127.0.0.1:8001/api/auth/user/${widget.userId}",
    ),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
    }),
  );

  setState(() {
    isLoading = false;
  });

  if (response.statusCode == 200) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Profile Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context, true);

  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Failed to Update Profile",
        ),
      ),
    );
  }
}

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage:
                      selectedImage != null
                          ? FileImage(selectedImage!)
                              as ImageProvider
                          : profileImage.isNotEmpty
                              ? NetworkImage(
                                  "http://127.0.0.1:8001/$profileImage?t=${DateTime.now().millisecondsSinceEpoch}",
                                )
                              : null,
                  child: selectedImage == null &&
                          profileImage.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 50,
                        )
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: pickImage,
                    child: Container(
                      padding:
                          const EdgeInsets.all(8),
                      decoration:
                          const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              keyboardType:
                  TextInputType.phone,
              decoration:
                  const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                prefixIcon:
                    Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  isLoading
                      ? "Saving..."
                      : "Save Changes",
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  foregroundColor:
                      Colors.white,
                ),
                onPressed: isLoading
                    ? null
                    : updateProfile,
                    
              ),
            ),
          ],
        ),
      ),
    );
  }
}