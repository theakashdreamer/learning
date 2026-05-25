import 'package:flutter/material.dart';
import 'package:schoolmanagementsystem/routes/routesname.dart';

import '../loginModules/entity/UserDetails.dart';
import '../loginModules/res/appStyles.dart';
import '../loginModules/view/aboutAppScreenActivity.dart';
import '../loginModules/view/aboutUsForAppScreenActivity.dart';
import '../loginModules/view/createPinActivity.dart';
import '../loginModules/view/dashBoardactivity.dart';
import '../loginModules/view/loginActivity.dart';
import '../loginModules/view/otpScreenActivity.dart';
import '../loginModules/view/registerWithMobileNumberActivity.dart';
import '../loginModules/view/splashActivity.dart';
import '../screens/home_screen.dart';
import '../screens/regestration/registration_done_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        //   return _slideFromRightRoute(SplashActivity(), settings);
        return _slideFromRightRoute(SplashActivity(), settings);
      case RoutesName.registerWithMobileNumberActivity:
        return _slideFromRightRoute(
            RegisterWithMobileNumberActivity(), settings);
      case RoutesName.otpScreenActivity:
        return _slideFromRightRoute(
            OtpScreenActivity(settings.arguments as UserDetails), settings);
      case RoutesName.createPinActivity:
        return MaterialPageRoute(
            builder: (context) => const CreatePinActivity());

      case RoutesName.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginActivity());

      case RoutesName.dashboardScreen:
        return _slideFromRightRoute(DashBoardActivity(), settings);

      case RoutesName.aboutAppScreen:
        return _slideFromRightRoute(AboutAppScreenActivity(), settings);

      case RoutesName.aboutUsForAppScreen:
        return _slideFromRightRoute(
            const AboutUsForAppScreenActivity(), settings);

      case RoutesName.registrationDoneScreen:
        return _slideFromRightRoute(const RegistrationDoneScreen(), settings);

      case RoutesName.homeScreen:
        return _slideFromRightRoute(HomeScreen(), settings);

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
              body: Center(
                  child: Text('No Routes Defined',
                      style: AppStyles.styleHintNormalSizeWithTextColor)));
        });
    }
  }

  static PageRouteBuilder _slideFromRightRoute(
      Widget page, RouteSettings settings) {
    return PageRouteBuilder(
        settings: settings,
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
              position: animation.drive(tween), child: child);
        });
  }
}
