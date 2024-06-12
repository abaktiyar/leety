// import cupertino widgets
// import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Map<String, String>>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      List<dynamic> jsonData = jsonDecode(userDataString);
      return jsonData.map((item) => Map<String, String>.from(item)).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leety',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black26,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error: ${snapshot.error}"); // Debugging statement
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var userData = snapshot.data ?? [];
            return ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                final submission = userData[index];
                return ListTile(
                  title: Text(submission['title'] ?? ''),
                  subtitle: Text(submission['dateTime'] ?? ''),
                );
              },
            );
          }
        },
      ),
    );
  }
}
