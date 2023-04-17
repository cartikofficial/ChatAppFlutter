// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groupie/Screens/registerscreen.dart';
import 'package:groupie/services/auth_services.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/widget.dart';
import '../services/shared_preferences.dart';
import 'home_screen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool isloading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  final ValueNotifier<bool> toogle = ValueNotifier<bool>(true);
  Authservices authservices = Authservices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? Center(
              child: CircularProgressIndicator(color: Constants().primarycolor))
          : SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 60,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Groupie",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Login now to see what they are talking!",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset("assets/images/login.png"),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: textinputdecopration.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Constants().primarycolor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value!)
                              ? null
                              : "Please enter correct email";
                        },
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                        valueListenable: toogle,
                        builder: (BuildContext context, dynamic value,
                            Widget? child) {
                          return TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            obscureText: toogle.value,
                            obscuringCharacter: "*",
                            decoration: textinputdecopration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Constants().primarycolor,
                              ),
                              suffix: InkWell(
                                onTap: () {
                                  toogle.value = !toogle.value;
                                },
                                child: Icon(
                                  toogle.value
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: Constants().primarycolor,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.length < 6) {
                                return "Password must have atleast 6 characters";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Constants().primarycolor,
                            elevation: 0,
                          ),
                          onPressed: () {
                            login();
                          },
                          child: const Text("Sign-in"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Dont have an account? ",
                          style: const TextStyle(fontSize: 13),
                          children: [
                            TextSpan(
                              text: "Register here",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextpage(context, const Registerscreen());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      authservices
          .signinuserwithemailandpassword(email, password, context)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettinguserdata(email);
          await Sharedprefererncedata.saveuserlogedinstatus(true);
          await Sharedprefererncedata.saveusername(snapshot.docs[0]["Name"]);
          await Sharedprefererncedata.saveuseremail(email);
          nextpagereplacement(context, const HomeScreen());
        }
        setState(() {
          isloading = false;
        });
      });
    }
  }
}
