
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:my_app/presentation/screens/home_screen/view/home_screen.dart';
import 'package:my_app/presentation/screens/login_screen/view/login_screen.dart';
import 'package:my_app/presentation/screens/network_error_screen/view/network_error_screen.dart';
import 'package:my_app/presentation/screens/otp_verify_screen/view/otp_verify_screen.dart';
import 'package:my_app/presentation/screens/splash_screen/view/splash_screen.dart';
import 'package:my_app/presentation/screens/user_registration_screen/view/user_registration.dart';
import 'package:my_app/routes/index.dart';

import 'route_name.dart';

RouteName _routeName = RouteName();

class AppRoute {
  final List<GetPage> getPages = [
    GetPage(
        name: routeName.splashScreen, page: () => const SplashScreen(),),
        GetPage(
        name: _routeName.loginScreen, page: () =>  LoginScreen(),
        
        ),
          GetPage(
        name: '/', page: () =>   HomeScreen(),
        ),
           GetPage(
        name: _routeName.userRegistration, page: () =>   UserRegistration(),
        ),
                   GetPage(
        name: _routeName.networkErrorScreen, page: () => const  NetworkErrorScreen(),
        ),
                   GetPage(
        name: _routeName.otpVerifyScreen, page: () =>  const OtpVerifyScreen(),
        ),
            
  ];
}
