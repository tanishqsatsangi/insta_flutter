import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //add img to firebase storage
  Future<String> uploadImageToStorage(String childPath, Uint8List file,
      bool isPost) async {
    Reference ref =
    _storage.ref().child(childPath).child(_auth.currentUser!.uid);
    if(isPost){
      String id=Uuid().v1();
     ref= ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref
    .
    getDownloadURL
    (
    );
  }
}
