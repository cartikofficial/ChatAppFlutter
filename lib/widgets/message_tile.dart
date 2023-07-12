import 'package:flutter/material.dart';
import 'package:groupie/shared/constants.dart';

class Messagetile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sendedbyme;
  const Messagetile({
    super.key,
    required this.message,
    required this.sender,
    required this.sendedbyme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // constraints: BoxConstraints(
      //   maxWidth: MediaQuery.of(context).size.width * 0.68,
      // ),
      padding: EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: sendedbyme ? 0 : 15,
        right: sendedbyme ? 15 : 0,
      ),
      alignment: sendedbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendedbyme
            ? EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25)
            : EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.25),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: sendedbyme
              ? const BorderRadius.only(
                  topRight: Radius.circular(22),
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(22),
                  topLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
          color: primarycolor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                wordSpacing: -0.8,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
