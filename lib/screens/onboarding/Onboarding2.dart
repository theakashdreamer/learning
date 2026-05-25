import 'package:flutter/material.dart';

import '../../loginModules/res/imagePaths.dart';
import 'Onboarding1.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

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
              child: Image.asset(ImagePaths.verifiedDocument),
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
            "All of the drivers and their Ambulance documents   ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "are verified by system. ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          /*Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Container(

              height: 52,
              width: 320,
              child:
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder()
                  ),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Onboarding3()));
                  }, child: Text(
                "Next",
                style: TextStyle(
                    color: Colors.white
                ),
              )),
            ),
          ),*/
        ],
      ),
    );
  }
}
