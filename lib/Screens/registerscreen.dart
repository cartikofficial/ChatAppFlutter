import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/screens/home_screen.dart';
import 'package:groupie/services/auth_services.dart';
import 'package:groupie/screens/login_in_screen.dart';
import 'package:groupie/services/shared_preferences.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  String name = "";
  String email = "";
  String password = "";
  bool isloading = false;
  final formkey = GlobalKey<FormState>();
  final Authservices authservice = Authservices();
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
                        const SizedBox(height: 10),
                        const Text(
                          textAlign: TextAlign.center,
                          "Creat your account now to chat and explore",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.asset("assets/images/register.png"),
                        const SizedBox(height: 15),
                        TextFormField(
                          cursorColor: primarycolor,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: textinputdecopration.copyWith(
                            labelText: "Name",
                            prefixIcon: Icon(Icons.person, color: primarycolor),
                          ),
                          onChanged: (value) {
                            setState(() => name = value);
                          },
                          validator: (value) {
                            return value!.isNotEmpty
                                ? null
                                : "Name can't be empty";
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          cursorColor: primarycolor,
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
                            return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value!)
                                ? null
                                : "Please enter a valid Email";
                          },
                        ),
                        const SizedBox(height: 20),
                        ValueListenableBuilder(
                          valueListenable: toogle,
                          builder: (context, value, child) {
                            return TextFormField(
                              cursorColor: primarycolor,
                              textAlignVertical: TextAlignVertical.center,
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
                                return value!.length < 6
                                    ? "Password must have atleast 6 characters"
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
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: primarycolor,
                            ),
                            onPressed: () => register(context),
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
                                    nextpagereplacement(
                                      context,
                                      const Loginscreen(),
                                    );
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

  void register(context) {
    if (formkey.currentState!.validate()) {
      showpopuploadingdialouge("Loading..", context);

      authservice
          .createuserwithemailandpassword(
        name.trim(),
        email.trim(),
        password.trim(),
        context,
      )
          .then((value) async {
        if (value == true) {
          await Sharedprefererncedata.saveuserlogedinstatus(true);
          await Sharedprefererncedata.saveuseremail(email);
          await Sharedprefererncedata.saveusername(name);

          Navigator.of(context).pop();

          nextpagereplacement(context, const HomeScreen());
        }
      });
    }
  }
}
