import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leety/graphql/leety_gql_client.dart';
import 'package:leety/intro/screen_3.dart';
import 'package:leety/intro/screen_1.dart';
import 'package:leety/intro/screen_2.dart';
import 'package:leety/pages/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

const int pageCount = 3;

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == pageCount - 1);
              });
            },
            children: [
              Screen1(),
              Screen2(),
              Screen3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.animateToPage(
                        // last page's index
                        pageCount - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  child: Text("Skip", style: TextStyle(color: Colors.white)),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: pageCount,
                  onDotClicked: (index) => {
                    _controller.animateToPage(index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease)
                  },
                  // add color to the dots
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () async {
                          // get userName from screen 3
                          String username = Screen3.userName;
                          print(username);
                          var userData = await fetchUserData(username, 15);
                          if (userData != null) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('userName', username);
                            await prefs.setString(
                                'userData', jsonEncode(userData));
                            await prefs.setBool('hasCompletedOnboarding', true);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                            await prefs.setBool('hasCompletedOnboarding', true);
                          } else {
                            // show error
                            print("Error");
                          }
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.ease);
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
                        )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
