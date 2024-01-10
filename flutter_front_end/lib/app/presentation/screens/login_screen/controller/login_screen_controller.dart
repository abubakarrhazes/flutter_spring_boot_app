// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_front_end/app/data/api-client/api_cient.dart';
import 'package:flutter_front_end/app/presentation/screens/login_screen/model/login_screen_model.dart';
import 'package:flutter_front_end/app/routes/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  var storage = FlutterSecureStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final apiClient = ApiClient();
  String? message;

  Rx<LoginScreenModel> loginScreenModelObj =
      LoginScreenModel(email: "", password: "").obs;
  Rx<bool> isShowPassword = true.obs;

  Future<void> logIn() async {
    loginScreenModelObj.update((val) {
      val?.email = emailController.text;
      val?.password = passwordController.text;
    });

    Get.dialog(
      Center(child: CircularProgressIndicator()), // showing a loading dialog
      barrierDismissible: false, // user must not close it manually
    );

    try {
      Response loginResponse = await apiClient.logIn(loginScreenModelObj.value);
      print("This is message reposnde ${loginResponse.body["message"]}");
      message = loginResponse.body['message'].toString();

      if (loginResponse.body['status'].toString() == 'success') {
        Get.back();
        Get.snackbar('Success', 'Login successful!');

        var headers = loginResponse.headers;
        var authorization = headers?['authorization'];
        await storage.write(key: 'token', value: authorization.toString());

        ///the 3 commented line is code to test that the login in process is working as intended
        // await storage.write(key: 'activeProfile', value:null);
        // var test = await storage.read(key: 'test');
        // print(test);
        var activeProfile = await storage.read(key: 'activeProfile');
        print(activeProfile);
        if (activeProfile == null) {
          //Get.offNamed(AppRoutes.chooseProfile);
        } else if (activeProfile == 'Creator') {
          //Get.offNamed(AppRoutes.homeCreatorContainerScreen);
        } else {
          //Get.offNamed(AppRoutes.influencerTabScreen);
        }
      } else {
        print(loginResponse.statusCode);
        Get.back();
        Get.snackbar('Failure',
            'login in failed ${loginResponse.body["message"].toString()}');
      }
    } catch (e) {
      Get.back();
      print(e);
      Get.snackbar('Error', 'Sever interrupted');
    }
  }
}
