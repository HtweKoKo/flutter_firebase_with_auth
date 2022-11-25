import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_firestore_app/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../image_service.dart';

class EditScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Person> snapshotData;

  const EditScreen({super.key, required this.snapshotData});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  CollectionReference<Person> _contacts = FirebaseFirestore.instance
      .collection("collection")
      .withConverter<Person>(
          fromFirestore: ((snapshot, _) => Person.fromMap(snapshot.data()!)),
          toFirestore: (person, _) => person.toMap());
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _address = TextEditingController();
  var name, image, id, age, address;
  bool _loading = false;
  bool _success = false;
  bool _error = false;
  File? profilePicutre;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name = widget.snapshotData.data().name;
    age = widget.snapshotData.data().age;
    address = widget.snapshotData.data().address;
    image = widget.snapshotData.data().imageUrl;
    id = widget.snapshotData.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Data")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                // TextFormField(
                //   initialValue: id,
                //   decoration: InputDecoration(
                //       hintText: "Enter ID",
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(10)))),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
              
                TextFormField(
                  onSaved: (str) {
                    name = str;
                  },
                  initialValue: name,
                  decoration: InputDecoration(
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (str) {
                    age = str;
                  },
                  initialValue: age,
                  decoration: InputDecoration(
                      hintText: "Enter age",
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (str) {
                    address = str;
                  },
                  initialValue: address,
                  decoration: InputDecoration(
                      hintText: "Enter address",
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                
                (image != null)
                    ? Image.network(
                        image,
                        height: 100,
                        width: 100,
                      )
                    : SizedBox(),
                ElevatedButton(onPressed: (){
                    _key.currentState!.save();
                  _addContacts();
                }, child: Text("edit")),
            
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addContacts() async {
    
    setState(() {
      _loading = true;
      _success = false;
      _error = false;
    });
    _contacts.doc(id).update({
      "name": name,
      "age": age,
      "address": address,
      // "timeStamp" :DateTime.now().microsecondsSinceEpoch,
     
    }).then((value) {
      _loading = false;
      _success = true;
      Navigator.pop(context);
    }).catchError((e) {
      _loading = false;
      _error = true;
    }).whenComplete(() {
      name = "";
      age = "";
      address = "";
    });
   

    // String? _imageUrl;
    // setState(() {
    //   _loading = true;
    //   _success = false;
    //   _error = false;
    // });
    // if (profilePicutre != null) {
    //   _imageUrl = await uploadImage(profilePicutre!);
    // }

    // _contacts
    //     .add(Person(
    //         name: _name.text,
    //         age: _age.text,
    //         address: _address.text,
    //         timeStamp: DateTime.now().microsecondsSinceEpoch,
    //         imageUrl: _imageUrl))
    //     .then((value) {
    //   setState(() {
    //     _loading = false;
    //     _success = true;
    //     Navigator.pop(context);
    //   });
    // }).catchError((e) {
    //   print("hahahahah" + e.toString());
    //   setState(() {
    //     _loading = false;
    //     _error = true;
    //   });
    // }).whenComplete(() {
    //   _name.text = "";
    //   _age.text = "";
    //   _address.text = "";
    // });
  }
}
