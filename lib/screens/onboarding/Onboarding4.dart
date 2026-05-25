import 'package:flutter/material.dart';

class Onboarding4 extends StatelessWidget {
  const Onboarding4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 130, left: 39, right: 39),
            child: Container(
              height: 164,
              width: 350,
              child: Image.asset("assets/images/Frame (2).png"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Verified Drivers",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "All of the drivers and their ambulance documents   ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "are verified by system.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
