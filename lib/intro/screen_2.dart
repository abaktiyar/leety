import 'package:flutter/material.dart';

const Color backgroundC = Color.fromARGB(255, 209, 65, 65);

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundC,
        alignment: Alignment(0, 0.1),
        child: Center(
          child: Text("We will help you get better at leetcode",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Arial")),
        ));
  }
}
