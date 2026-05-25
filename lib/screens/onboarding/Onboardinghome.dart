import 'package:flutter/material.dart';
import 'package:schoolmanagementsystem/loginModules/view/loginActivity.dart';
import 'package:schoolmanagementsystem/screens/select_city/selectcity.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/storage/hive_storage.dart';
import 'Onboarding1.dart';
import 'Onboarding2.dart';
import 'Onboarding3.dart';

class Onboardinghome extends StatefulWidget {
  const Onboardinghome({super.key});

  @override
  State<Onboardinghome> createState() => _OnboardinghomeState();
}

class _OnboardinghomeState extends State<Onboardinghome> {
  final PageController _controller = PageController();
  int currentPageIndex = 0; // current page track
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (currentPageIndex > 0) {
          _controller.previousPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
          return false; // consume back press
        }
        return true; // first page pe app exit allowed
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: currentPageIndex > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                )
              : null,
        ),
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                  isLastPage = (index == 2); // last page index
                });
              },
              children: const [
                Onboarding1(),
                Onboarding2(),
                Onboarding3(),
                // Onboarding4(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: size.height * 0.08,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 8,
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 6,
                          shadowColor: Colors.black54,
                        ),
                        onPressed: () async {
                          if (isLastPage) {
                            await HiveStorage.init();
                            HiveStorage.saveBool(HiveStorage.keyOnBoarding, true);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectCity()),
                            );
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          isLastPage ? "Get Started" : "Next",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
