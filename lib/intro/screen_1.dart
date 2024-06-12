import 'package:flutter/material.dart';

const Color backgroundC = Color.fromARGB(255, 253, 187, 101);

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundC,
      child: Center(
        child: Text(
          "Welcome to Leety",
          style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "Arial"),
        ),
      ),
    );
  }
}
