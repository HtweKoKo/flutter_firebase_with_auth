import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_firestore_app/image_service.dart';
import 'package:flutter/material.dart';

import '../models/person.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final CollectionReference<Person> _contacts = FirebaseFirestore.instance.collection("collection")
  .withConverter<Person>(fromFirestore:((snapshot, _) =>Person.fromMap(snapshot.data()!) ) , toFirestore: ((person,_ ) =>person.toMap() ));
    bool _loading = false;
    bool _success = false;
    bool _error = false;
    File? profilePicutre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AddData")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller:_name ,
              decoration: InputDecoration(
                hintText: "Enter Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller:_age ,
              decoration: InputDecoration(
                hintText: "Enter age",
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
              ),
            ),
            SizedBox(height: 20,),

            TextFormField(
              controller:_address ,
              decoration: InputDecoration(
                hintText: "Enter address",
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
              ),
            ),
            SizedBox(height: 10,),
            IconButton(onPressed: ()async{
              File? image = await chooseImage();
              setState(() {
                 profilePicutre =image;
              });

           
            }, 
            icon: Icon(Icons.image)),
            (profilePicutre != null) ? Image.file(profilePicutre!,
            width: 100,
            height: 100,
            fit: BoxFit.fill,
            ): const SizedBox(),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: _addContacts,
             child: Text("Svae document")),
             (_loading) ? CircularProgressIndicator() : SizedBox(),
             (_success) ? Text("success") : SizedBox(),
             (_error) ? Text("unknown error occur" ) : SizedBox()
          ],
        ),
      ),
    );
  }
  Future<void>  _addContacts()async{
    String ? _imageUrl;
      setState(() {
        _loading = true;
        _success = false;
        _error = false;
      });
      if(profilePicutre !=null) {
        _imageUrl = await uploadImage(profilePicutre!);
      }
    
    _contacts.add(
     Person(
      name: _name.text,
      age: _age.text,
      address: _address.text,
    //  timeStamp: DateTime.now().microsecondsSinceEpoch,
      imageUrl: _imageUrl
     )
    ).then((value){
    setState(() {
      _loading = false;
      _success = true;
     Navigator.pop(context);
    
    });

    }
    ).catchError((e)
    {
      print("hahahahah" +e.toString());
      setState(() {
        _loading = false;
        _error = true;
      });
    }
    ).whenComplete(() {
      _name.text = "";
      _age.text = "";
      _address.text = "";
    
    });
  }
}