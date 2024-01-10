// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_front_end/app/data/api-client/api_cient.dart';
import 'package:flutter_front_end/app/presentation/screens/register_screen/model/register_screen_model.dart';
import 'package:flutter_front_end/app/routes/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class RegisterScreenController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final otherNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final apiClient = ApiClient();
  final isShowPassWord = true.obs;
  final isCheckBox = false.obs;

  var signUpModelObj = RegisterScreenModel(
    firstName: '',
    lastName: '',
    otherName: '',
    email: '',
    password: '',
    termsAndConditions: false,
  ).obs;

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    otherNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

   var storage = FlutterSecureStorage();

  Future<void> signUp() async {
    signUpModelObj.update((val) {
      val?.firstName = firstNameController.text;
      val?.lastName = lastNameController.text;
      val?.otherName = lastNameController.text;
      val?.email = emailController.text;
      val?.password = passwordController.text;
      val?.termsAndConditions = isCheckBox.value;
    });

    Get.dialog(
      Center(child: CircularProgressIndicator()), // showing a loading dialog
      barrierDismissible: false, // user must not close it manually
    );

    try {
      Response loginResponse = await apiClient.signUp(signUpModelObj.value);
      var headers = loginResponse.headers;
      var authorization = headers?['authorization'];

      if (loginResponse.isOk) {
        Get.back();
        Get.snackbar('Success', 'Sign up successful!');
        await storage.write(key: 'token', value: authorization.toString());
        print(authorization);
        print(signUpModelObj.value.email);
        Get.toNamed(
          AppRoutes.initialScreen,
          arguments: {
            'email': signUpModelObj.value.email,
            'code': '0000',
          },
        );
      } else {
        print(loginResponse.statusCode);
        Get.back();
        Get.snackbar(
            'Failure', 'Sign up failed! ${loginResponse.body['message']}');
      }
    } catch (e) {
      print(e);
      Get.back();
      Get.snackbar('Error', 'Something went wrong during sign up.');
    }
  }
}
