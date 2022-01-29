import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/resources/firestore_provider.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/strings.dart';
import 'package:social_media_app/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? imgFile;
  final TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;

  void clearImage() {
    setState(() {
      imgFile = null;
    });
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(Strings.CREATE_A_POST),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(16),
                child: const Text(Strings.TAKE_A_PHOTO),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    imgFile = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(16),
                child: const Text(Strings.CHOOSE_FROM_GALLERY),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    imgFile = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(16),
                child: const Text(Strings.CANCEL),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return imgFile == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: getAppBar(user),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a Caption....",
                          border: InputBorder.none,
                        ),
                        maxLines: 10,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(imgFile!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }

  AppBar getAppBar(User user) {
    return AppBar(
      backgroundColor: mobileBackgroundColor,
      leading: IconButton(
        onPressed: clearImage,
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text(Strings.POST_TO),
      centerTitle: false,
      actions: [
        TextButton(
          onPressed: () => _postImage(user.uid, user.userName, user.photoUrl),
          child: const Text(
            Strings.POST,
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _postImage(
    String uid,
    String userName,
    String profileImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
          descriptionController.text, uid, imgFile!, userName, profileImage);
      if (res == Strings.SUCCESS) {
        clearImage();
        showSnackBar("Posted", context);
      } else {
        showSnackBar(res, context);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }
}
