import 'package:flutter/material.dart';
import 'package:groupie/shared/constants.dart';

class Messagetile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sendedbyme;
  const Messagetile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sendedbyme});

  @override
  State<Messagetile> createState() => _MessagetileState();
}

class _MessagetileState extends State<Messagetile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: widget.sendedbyme ? 0 : 15,
        right: widget.sendedbyme ? 15 : 0,
      ),
      alignment:
          widget.sendedbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sendedbyme
            ? const EdgeInsets.only(left: 60)
            : const EdgeInsets.only(right: 60),
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
            borderRadius: widget.sendedbyme
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
            color: Constants().primarycolor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                wordSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
