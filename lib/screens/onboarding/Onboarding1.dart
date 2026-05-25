import 'package:flutter/material.dart';

import '../../loginModules/res/imagePaths.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

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
              child: Image.asset(ImagePaths.booking),
            ),
          ),
          Text(
            "Easy booking",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "We provide easy cab booking solution with  ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "reasonable price. ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 30,
          ),

          /*  Padding(
            padding: const EdgeInsets.only(top: 150),
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Onboarding2()));
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
