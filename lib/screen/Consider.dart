import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'home.dart';

class Consider extends StatefulWidget {
  const Consider({Key? key}) : super(key: key);

  @override
  State<Consider> createState() => _ConsiderState();
}

class _ConsiderState extends State<Consider> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _otp = TextEditingController();
  bool send = false;
  bool _loading = false;
  String? verificationId ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: isLogin(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            User? user = snapshot.data;
            if (user == null) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: (send)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _otp,
                              decoration: InputDecoration(
                                hintText: "Enter OTP code",
                                  border: OutlineInputBorder())),
                          ElevatedButton(

                              onPressed: ()async {
                               
                                if(_otp.text.length >4){
                                 setState(() {
                                  _loading = true;
                                });
                               PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId:verificationId! , smsCode: _otp.text);
                               FirebaseAuth.instance.signInWithCredential(credential).then((value){})
                               .catchError((e){});
                                
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("enter valid otp")));
                                }
                              

                              }, child: Text("Verify OTP"))
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                              controller: _phone,
                              decoration: InputDecoration(
                                  hintText: "Enter your phone number",
                                  prefixText: "09  ",
                                  border: OutlineInputBorder())),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                _loading = true;
                                  
                                });
                                if (_phone.text.length > 5) {
                                  FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber: "+959${_phone.text}",
                                      verificationCompleted: (credential) {},
                                      verificationFailed: (expection) {},
                                      codeSent: (s, i) {
                                        verificationId = s;
                                        setState(() {
                                          send = true;
                                          _loading = false;
                                        });
                                        
                                      },
                                      codeAutoRetrievalTimeout: (timeout) {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("something was wrong")));
                                }
                              },
                              child: Text("Get OTP")),
                          (_loading) ? CircularProgressIndicator() : SizedBox()
                        ],
                      ),
              );
            }
            return Home();
          })),
    );
  }

  Stream<User?> isLogin() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
