import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:leety/graphql/leety_gql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, String>>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<List<Map<String, String>>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      List<dynamic> jsonData = jsonDecode(userDataString);
      return jsonData.map((item) => Map<String, String>.from(item)).toList();
    }
    return [];
  }

  Future<void> _refreshData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString("userName");
    if (userName != null) {
      var userData = await fetchUserData(userName, 15);
      await prefs.setString('userData', jsonEncode(userData));
      setState(() {
        _userDataFuture = _getUserData();
      });
    }
    // AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //         id: 1,
    //         channelKey: "leety_channel",
    //         title: "Leety",
    //         body: "Checking notifications..."));
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
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
