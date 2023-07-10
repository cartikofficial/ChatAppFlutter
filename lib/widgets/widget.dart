import 'package:flutter/material.dart';

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
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void showsnackbar(context, color, e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 8),
      content: Text(e.message.toString()),
      backgroundColor: color,
    ),
  );
}
