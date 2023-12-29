import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(
      {super.key,
      required this.onPickImage,
      this.defaultImage = 'assets/images/imperial_logo.png'});

  final void Function(File pickedImage) onPickImage;
  final String defaultImage;

  @override
  State<StatefulWidget> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile; // Variable to hold the image file

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      // Corrected the condition check here
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImageFile != null
              ? FileImage(_pickedImageFile!)
              : AssetImage(widget.defaultImage)
                  as ImageProvider, // Default image
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: Text(
              "Add Image",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ))
      ],
    );
  }
}
