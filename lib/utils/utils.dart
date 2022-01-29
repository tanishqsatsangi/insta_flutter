import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'global_variables.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return file.readAsBytes();
  }
  print("No Image Selected");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

bool isWebScreenSize(BuildContext context) {
  return MediaQuery.of(context).size.width > webScreenSize;
}

Center getCircularProgressIndicator(){
  return const Center(
    child: CircularProgressIndicator(),
  );
}
