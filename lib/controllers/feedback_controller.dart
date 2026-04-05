import 'dart:convert';
import 'package:admin/constants/constants.dart';
import 'package:admin/core/constats/links.dart';
import 'package:admin/models/feedback_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FeedbackController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }

  // ✅ STORE FEEDBACK LIST
  RxList<Datum> feedbackList = <Datum>[].obs;


  // 🚀 FETCH ALL FEEDBACKS FUNCTION
  Future<void> fetchFeedbacks() async {
    setLoading = true;

    String? token = box.read("token");

    Uri url = Uri.parse(getAllFeedbacksUrl); // 🔥 make sure this exists

    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        FeedbackResponse feedbackResponse =
            FeedbackResponse.fromJson(data);

        feedbackList.value = feedbackResponse.data;

        setLoading = false;

      } else {
        setLoading = false;

        Get.snackbar(
          "Failed",
          data["message"] ?? "Unable to fetch feedbacks",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline),
        );
      }
    } catch (e) {
      setLoading = false;
      debugPrint("Fetch Feedback Error: ${e.toString()}");

      Get.snackbar(
        "Error",
        "Something went wrong while fetching feedbacks",
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error_outline),
      );
    }
  }

  // ✅ AUTO LOAD WHEN CONTROLLER INIT
  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }
}