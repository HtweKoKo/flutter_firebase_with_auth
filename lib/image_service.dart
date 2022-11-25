

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> chooseImage()async{
    ImagePicker imagePicker = ImagePicker();
  XFile? file =  await imagePicker.pickImage(source: ImageSource.gallery);
    if(file != null){
      return File(file.path);
    }
    return null;

}
Future<String?> uploadImage(File image)async{
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  try{
 Reference ref = await firebaseStorage.ref("image file").child(DateTime.now().toString()+ ".jpg");

UploadTask uploadTask = ref.putFile(image);
TaskSnapshot taskSnapshot = await uploadTask;
  String imageUrl = await taskSnapshot.ref.getDownloadURL();
  return imageUrl;
  }catch(e){
    return null;
  }
  

}