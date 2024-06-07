import 'dart:convert';
import 'dart:io'; // Import the 'dart:io' library

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? image;

  Map<String, dynamic> profileDetails = {};

  selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? getImages = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (getImages != null) {
      File imageFile = File(getImages.path); // Create a File object
      if (await imageFile.exists()) {
        // Check if the file exists
        image = getImages.path;
        print(image);
        update();
      } else {
        print("Error: File does not exist.");
        // Handle the error accordingly
      }
    }
  }

  updateProfile() async {
    Map<String, dynamic> information = {
      'image': image!,
      'name': nameController.text,
      'email': emailController.text,
      'contact': contactController.text,
      'address': addressController.text
    };

    var encodedData = jsonEncode(information);

    print("================= ${encodedData}");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('profileData', encodedData);

    getProfile();
  }

  getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? profileData = prefs.getString('profileData');
    if (profileData != null) {
      var decodedData = jsonDecode(profileData);
      profileDetails = decodedData;
      update();
    }
  }

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }
}
