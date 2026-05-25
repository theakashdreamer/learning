import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../globalClass/globalClass.dart';
import '../res/appStrings.dart';
import '../res/appStyles.dart';


class AboutAppScreenActivity extends StatefulWidget {
  const AboutAppScreenActivity({super.key});

  @override
  State<AboutAppScreenActivity> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreenActivity>
    with SingleTickerProviderStateMixin {
  PackageInfo? _packageInfo;

  late AnimationController _controller;
  late Animation<double> _animation;
  String? _versionCode;

  @override
  void initState() {
    super.initState();
    _getVersionCode();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1, curve: Curves.easeInOut),
      ),
    );
    Future.delayed(Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  void _getVersionCode() async {
    String code = await GlobalClass.getAppVersion();
    setState(() {
      _versionCode = code;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.getString('aboutApp')!),
          leading: GestureDetector(
              onTap: () => {Navigator.of(context).pop()},
              child: Icon(Icons.arrow_back_ios_new_sharp)),
        ),
        body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(100.0 * (1 - _animation.value), 0.0),
              child: Opacity(
                opacity: _animation.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text(
                        AppStrings.getString("aboutUsForApp")!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: AppStyles.textStyleForVersionCodeBlack(
                          _versionCode != null
                              ? 'Version $_versionCode'
                              : 'Version 1.0.0'),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
