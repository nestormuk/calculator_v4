import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

Future<void> _uploadImageToFirebase(File image) async {
  String fileName = basename(image.path);
  Reference storageRef = FirebaseStorage.instance.ref().child('profiles/$fileName');
  UploadTask uploadTask = storageRef.putFile(image);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();

  // You can now save the downloadUrl to Firestore or your database
}
