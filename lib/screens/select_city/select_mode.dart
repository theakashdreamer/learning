import 'package:flutter/material.dart';
import 'package:schoolmanagementsystem/screens/select_city/selectcity.dart';

import '../../data/storage/hive_storage.dart';
import '../../loginModules/res/imagePaths.dart';
import '../../loginModules/view/loginActivity.dart';
import '../../widgets/AnimatedButton.dart';

class Selectmode extends StatelessWidget {
  Selectmode({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SelectCity()),
              );
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePaths.splashScreen),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.1),

                  // Logo
                  Row(
                    children: [
                      Image.asset("assets/images/Vectorwhite.png", height: 40),
                      const SizedBox(width: 10),
                      const Text(
                        "UPCHAR\nSARTHI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Welcome
                  Row(
                    children: const [
                      Text(
                        "Welcome to ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "UPCHAR SARTHI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    "Fastest Ambulance Booking App(UPCHAR SARTHI)- Your Emergency, Our Priority ",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  // Animated Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedButton(
                        label: "I’m a Passenger",
                        backgroundColor: Colors.white.withOpacity(0.15),
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        onTap: () async {
                          await HiveStorage.init();
                          HiveStorage.saveBool(HiveStorage.keySelectMode, true);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginActivity() /*const Loginscreen()*/),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
