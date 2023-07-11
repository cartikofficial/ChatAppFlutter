import 'package:flutter/material.dart';
import 'package:groupie/shared/constants.dart';

const textinputdecopration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffee7b64), width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffee7b64), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffee7b64), width: 2),
  ),
);

void nextpage(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextpagereplacement(context, page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}

void snackbarmessage(context, color, e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 8),
      content: Text(e.message.toString()),
      backgroundColor: color,
    ),
  );
}

void showpopuploadingdialouge(String msg, context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Constants().primarycolor,
              ),
              const SizedBox(width: 20),
              Text(msg, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    ),
  );
}
