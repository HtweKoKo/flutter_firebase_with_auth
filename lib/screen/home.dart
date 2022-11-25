import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firestore_app/models/person.dart';
import 'package:firebase_firestore_app/screen/addScreen.dart';
import 'package:firebase_firestore_app/screen/editScreen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot<Person>> contact = FirebaseFirestore.instance
      .collection("collection")
      .withConverter<Person>(
          fromFirestore: (snapshot, _) => Person.fromMap(snapshot.data()!),
          toFirestore: ((person, _) => person.toMap()))
     
      .snapshots();
  var _deleteContacts = FirebaseFirestore.instance.collection("collection");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
       IconButton(onPressed: (){
        FirebaseAuth.instance.signOut();
       }, 
       icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddScreen()));
          }),
      body: StreamBuilder<QuerySnapshot<Person>>(
          stream: contact,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Person>>? contactDocs =
                  snapshot.data?.docs;
              if (contactDocs != null) {
                return ListView.builder(
                    itemCount: contactDocs.length,
                    itemBuilder: ((context, index) {
                      QueryDocumentSnapshot<Person> listData =
                          contactDocs[index];
                      return Card(
                        child: ListTile(
                          leading: (listData.data().imageUrl != null)
                              ? Image.network(listData.data().imageUrl!)
                              : SizedBox(
                                child: Icon(Icons.person,),
                              ),
                          title: Row(
                            children: [
                              Text(
                                listData.data().name ?? "",
                                style: TextStyle(fontSize: 20),
                              ),

                              SizedBox(width: 20,),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditScreen(
                                                  snapshotData: listData,
                                                )));
                                  },
                                  icon: Icon(Icons.edit))
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _deleteContacts.doc(listData.id).delete();
                              },
                              icon: Icon(Icons.delete)),
                          subtitle: Text(listData.data().address ?? ""),
                        ),
                      );
                    }));
              } else {
                Text("Empty data");
              }
            }
            if (snapshot.hasError) {
              return Text("error : " + snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          })),
    );
  }
}
