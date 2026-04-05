import 'dart:convert';
import 'package:admin/screens/auth/login_screen.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../core/constats/links.dart';
import '../models/api_error_model.dart';
import '../models/login_response.dart';

class LoginController extends GetxController{
  final box = GetStorage();

  RxBool _isLoading = false.obs;

  bool get isLoading =>_isLoading.value;

  set setLoading(bool newState){
    _isLoading.value = newState;
  }

  RxList<LoginResponse> _users = <LoginResponse>[].obs;
  List<LoginResponse> get users => _users;

  void loginFunction(String data) async{
    setLoading = true;

    Uri url =Uri.parse(appBaseLoginUrl);

    Map<String, String> headers = {'Content-Type': 'application/json'};

    try{
      var response = await http.post(
        url, headers: headers, body: data
      );

      if(response.statusCode == 200){
        LoginResponse data = loginResponseFromJson(response.body);

        String userId = data.id;
        String userData = jsonEncode(data);

        box.write(userId, userData);
        box.write("token", data.userToken);
        box.write("userId", data.id);

        setLoading = false;

        Get.snackbar(
            "You successfully loggedin", "Explore Projects",
          colorText: kLightWhite,
          backgroundColor: Colors.green,
          icon: const Icon(Ionicons.airplane_sharp)
        );

        Get.offAll(() => DashboardScreen());



      }else{
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
            "Failed to login", error.message,
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error_outline)
        );

      }
    }
    catch(e){
      debugPrint(e.toString());
    }
  }

  void logout() {
    box.erase();
    Get.offAll(() => LoginScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 900)
    );
  }

  LoginResponse? getUserInfo(){
    String? userId = box.read("userId");
    String? data;

    if(userId != null){
      data = box.read(userId.toString());
    }
    if(data != null){
      return loginResponseFromJson(data);
    }
    return null;
  }

  Future<void> fetchUsers() async {
    setLoading = true;

    try {
      String token = box.read("token");

      Uri url = Uri.parse(getAllUsersUrl);

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {

        List<dynamic> jsonData = jsonDecode(response.body);

        _users.value =
            jsonData.map((e) => LoginResponse.fromJson(e)).toList();


      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint(e.toString());

      Get.snackbar(
        "Error",
        "Something went wrong",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }

    setLoading = false;
  }

}