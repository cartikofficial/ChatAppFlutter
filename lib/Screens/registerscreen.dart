// ignore_for_file: use_build_context_synchronously
import '../widgets/widget.dart';
import '../shared/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groupie/Screens/home_screen.dart';
import 'package:groupie/services/auth_services.dart';
import 'package:groupie/Screens/login_in_screen.dart';
import 'package:groupie/services/shared_preferences.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  bool isloading = false;
  final formkey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  final ValueNotifier<bool> toogle = ValueNotifier<bool>(true);
  Authservices authservice = Authservices();

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
                    vertical: 70,
                    horizontal: 20,
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
                        "Creat your account now to chat and explore",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset("assets/images/register.png"),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: textinputdecopration.copyWith(
                          labelText: "Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Constants().primarycolor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "name can't be empty";
                          }
                        },
                      ),
                      const SizedBox(height: 15),
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
                              : "Please enter a valid value";
                        },
                      ),
                      const SizedBox(height: 15),
                      ValueListenableBuilder(
                        valueListenable: toogle,
                        builder: (context, value, child) {
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
                      const SizedBox(height: 15),
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
                            register();
                          },
                          child: const Text("Sign-in"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Alredy have an account? ",
                          style: const TextStyle(fontSize: 13),
                          children: [
                            TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextpage(context, const Loginscreen());
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

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      authservice
          .registeruserwithemailandpassword(name, email, password, context)
          .then((value) async {
        if (value == true) {
          // saving data to shared prefrence
          await Sharedprefererncedata.saveuserlogedinstatus(true);
          await Sharedprefererncedata.saveuseremail(email);
          await Sharedprefererncedata.saveusername(name);
          nextpagereplacement(context, const HomeScreen());
        } else {
          setState(() {
            isloading = false;
          });
        }
      });
    }
  }
}
