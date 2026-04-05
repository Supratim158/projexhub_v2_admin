import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/constats/links.dart';

class AIController extends GetxController {
  var isLoading = false.obs;
  var result = "".obs;


  // 🔹 SUMMARY
  Future<void> getSummary(String projectId) async {
    try {
      isLoading.value = true;
      result.value = "";

      final response = await http.get(
        Uri.parse("$getSummaryAiUrl/$projectId"),
      );

      final data = jsonDecode(response.body);
      result.value = data['summary'];

    } catch (e) {
      result.value = "Error: $e";
    }
    isLoading.value = false;
  }

  // 🔹 CHAT
  Future<void> askQuestion(String projectId, String question) async {
    try {
      isLoading.value = true;
      result.value = "";

      final response = await http.post(
        Uri.parse("$getChatAiUrl/$projectId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": question}),
      );

      final data = jsonDecode(response.body);
      result.value = data['answer'];

    } catch (e) {
      result.value = "Error: $e";
    }
    isLoading.value = false;
  }

  // 🔹 SCORE
  Future<void> getScore(String projectId) async {
    try {
      isLoading.value = true;
      result.value = "";

      final response = await http.get(
        Uri.parse("$getProjectScoreAiUrl/$projectId"),
      );

      final data = jsonDecode(response.body);
      result.value = data['evaluation'];

    } catch (e) {
      result.value = "Error: $e";
    }
    isLoading.value = false;
  }
}