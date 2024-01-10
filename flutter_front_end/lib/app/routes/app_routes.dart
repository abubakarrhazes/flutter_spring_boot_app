// ignore_for_file: prefer_const_constructors

import 'package:flutter_front_end/app/presentation/screens/login_screen/binding/login_screen_binding.dart';
import 'package:flutter_front_end/app/presentation/screens/login_screen/login_screen.dart';
import 'package:flutter_front_end/app/presentation/screens/register_screen/binding/register_screen_binding.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String initialScreen = '/login';
  static const String registerScreen = '/register';
  static const String homeScreen = '/home';

  static List<GetPage> screens = [
    GetPage(
        name: initialScreen,
        page: () => LoginScreen(),
        bindings: [LoginScreenBinding()]),
    GetPage(
        name: initialScreen,
        page: () => LoginScreen(),
        bindings: [RegisterScreenBinding()]),
  ];
}
