import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor/screen/edit_image_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  ImagePicker imagePicker = ImagePicker();
  void getGalleryImage() async {
    final picker = await imagePicker.pickImage(source: ImageSource.gallery);
    try {
      if (picker != null) {
         image = File(picker.path);
       Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditImageScreen(selectedImage: image!.path)));
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            onPressed: () {
              getGalleryImage();
            },
            icon: const Icon(Icons.image)),
      ),
    );
  }
}
