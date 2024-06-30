import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color backgroundC = Color.fromARGB(255, 228, 228, 228);

class Screen3 extends StatelessWidget {
  const Screen3({Key? key}) : super(key: key);

  // userName should be accessible from other files
  static String userName = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundC,
      child: Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        alignment: Alignment(0, -0.2),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: TextField(
          onChanged: (value) {
            // Update the userName variable
            userName = value;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Enter username",
            prefixIcon: const Icon(CupertinoIcons.person_solid),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
