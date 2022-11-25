import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_firestore_app/screen/Consider.dart';
import 'package:firebase_firestore_app/screen/home.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    
    MaterialApp(
      debugShowCheckedModeBanner: false,
        home:Consider()
    )
  );
 
}
 