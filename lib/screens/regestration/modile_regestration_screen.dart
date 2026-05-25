import 'package:flutter/material.dart';

class ModileRegestrationScreen extends StatelessWidget {
  const ModileRegestrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              // Title
              Text(
                "Phone Verification",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // Image/Illustration
              Center(
                child: Image.asset(
                  "assets/images/Frame (3).png",
                  width: size.width * 0.7,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // Phone Number Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/india.png",
                      height: 24,
                      width: 34,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: "Phone Number",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.05),

              // Verify Number Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                   /* OTP otp = OTP();
                    otp.OTP_Number='1234';
                    otp.User_Mobile='9140364148';
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OtpScreenActivity(otp),
                      ),
                    );*/
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Verify Number",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
