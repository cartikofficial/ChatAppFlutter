import 'home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import '../services/shared_preferences.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/services/auth_services.dart';
import 'package:groupie/screens/registerscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupie/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  String email = "";
  String password = "";
  bool isloading = false;
  final formkey = GlobalKey<FormState>();
  final Authservices authservices = Authservices();
  final ValueNotifier<bool> toogle = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              physics: constbouncebehaviour,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                alignment: Alignment.center,
                child: Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Groupie",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          textAlign: TextAlign.center,
                          "Login now to see what they are talking!",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Image.asset("assets/images/login.png"),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: textinputdecopration.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: primarycolor,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Please enter your Email";
                            } else {
                              return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(value!)
                                  ? null
                                  : "Please enter a Valid Email";
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        ValueListenableBuilder(
                          valueListenable: toogle,
                          builder: (context, value, Widget? child) {
                            return TextFormField(
                              obscureText: toogle.value,
                              obscuringCharacter: "*",
                              decoration: textinputdecopration.copyWith(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: primarycolor,
                                ),
                                suffix: InkWell(
                                  onTap: () => toogle.value = !toogle.value,
                                  child: Icon(
                                    toogle.value
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: primarycolor,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                return value!.isEmpty
                                    ? "Enter your Password"
                                    : null;
                              },
                              onChanged: (value) {
                                setState(() => password = value);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primarycolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => login(context),
                            child: const Text("Login-in"),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Google Sign-in
                        ElevatedButton.icon(
                          style: const ButtonStyle(
                            enableFeedback: true,
                          ),
                          onPressed: () => googlesignin(context),
                          icon: const FaIcon(FontAwesomeIcons.google),
                          label: const Text("Sign-in with Google"),
                        ),

                        const SizedBox(height: 12),
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
            ),
          ),
        ),
      ),
    );
  }

  void login(context) {
    if (formkey.currentState!.validate()) {
      showpopuploadingdialouge("Loading..", context);

      authservices
          .signinuserwithemailandpassword(
        email.trim(),
        password.trim(),
        context,
      )
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await Databaseservice().gettinguserdata(
            email,
          );

          await Sharedprefererncedata.saveuseremail(email.trim());
          await Sharedprefererncedata.saveusername(snapshot.docs[0]["Name"]);
          await Sharedprefererncedata.saveuserlogedinstatus(true);

          nextpagereplacement(context, const HomeScreen());
        }
      });
    }
  }

  void googlesignin(context) async {
    await Authservices().signinwithgoogle(context).then(
      (value) {
        value == true ? nextpagereplacement(context, const HomeScreen()) : null;
      },
    );
  }
}
