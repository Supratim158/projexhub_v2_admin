import 'dart:convert';
import 'package:admin/models/project_resoponse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/project_model.dart';
import '../models/api_error_model.dart';
import '../core/constats/links.dart';
import '../constants/constants.dart';

class ProjectController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  RxList<ProjectModel> _projects = <ProjectModel>[].obs;
  List<ProjectModel> get projects => _projects;

  RxList<ProjectResponse> _myProjects = <ProjectResponse>[].obs;
  List<ProjectResponse> get myProjects => _myProjects;

  // ================= DASHBOARD METRICS =================
  RxInt totalProjectsCount = 0.obs;
  RxInt pendingProjectsCount = 0.obs;
  RxInt approvedProjectsCount = 0.obs;
  RxInt rejectedProjectsCount = 0.obs;
  RxList<int> monthlySubmissions = List.filled(12, 0).obs;

  Future<void> fetchDashboardStats() async {
    // Only toggle global loading if needed, otherwise rely on silent updating
    try {
      String token = box.read("token");
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", 
      };

      var responses = await Future.wait([
        http.get(Uri.parse(pendingProjectUrl), headers: headers),
        http.get(Uri.parse(approvedProjectUrl), headers: headers),
        http.get(Uri.parse(rejectedProjectUrl), headers: headers),
      ]);

      int pending = 0;
      int approved = 0;
      int rejected = 0;
      List<ProjectResponse> allFetchedProjects = [];

      // Parse Pending
      if (responses[0].statusCode == 200) {
        List<dynamic> json = jsonDecode(responses[0].body);
        pending = json.length;
        allFetchedProjects.addAll(json.map((e) => ProjectResponse.fromJson(e)));
      }
      
      // Parse Approved
      if (responses[1].statusCode == 200) {
        List<dynamic> json = jsonDecode(responses[1].body);
        approved = json.length;
        allFetchedProjects.addAll(json.map((e) => ProjectResponse.fromJson(e)));
      }
      
      // Parse Rejected
      if (responses[2].statusCode == 200) {
        List<dynamic> json = jsonDecode(responses[2].body);
        rejected = json.length;
        allFetchedProjects.addAll(json.map((e) => ProjectResponse.fromJson(e)));
      }

      pendingProjectsCount.value = pending;
      approvedProjectsCount.value = approved;
      rejectedProjectsCount.value = rejected;
      totalProjectsCount.value = pending + approved + rejected;

      // Extract monthly data
      List<int> months = List.filled(12, 0);
      for (var project in allFetchedProjects) {
        // month is 1-12. array index is 0-11
        if (project.createdAt != null) {
          int mIndex = project.createdAt.month - 1;
          months[mIndex]++;
        }
      }
      monthlySubmissions.value = months;

    } catch (e) {
      debugPrint("Dashboard Stats Fetch Error: $e");
    }
  }

  // ================= FETCH PROJECTS =================
  Future<void> fetchPendingProjects({String status = "pending"}) async {
    setLoading = true;

    try {
      String token = box.read("token");

      Uri url = Uri.parse(pendingProjectUrl);

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {

        // 🔥 If API returns LIST of projects
        List<dynamic> jsonData = jsonDecode(response.body);

        _myProjects.value =
            jsonData.map((e) => ProjectResponse.fromJson(e)).toList();

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

  Future<void> fetchApprovedProjects({String status = "approved"}) async {
    setLoading = true;

    try {
      String token = box.read("token");

      Uri url = Uri.parse(approvedProjectUrl);

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {

        // 🔥 If API returns LIST of projects
        List<dynamic> jsonData = jsonDecode(response.body);

        _myProjects.value =
            jsonData.map((e) => ProjectResponse.fromJson(e)).toList();


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

  Future<void> fetchRejectedProjects({String status = "rejected"}) async {
    setLoading = true;

    try {
      // String token = box.read("token");

      Uri url = Uri.parse(rejectedProjectUrl);

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {

        // 🔥 If API returns LIST of projects
        List<dynamic> jsonData = jsonDecode(response.body);

        _myProjects.value =
            jsonData.map((e) => ProjectResponse.fromJson(e)).toList();

        

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

  // ================= FETCH PROJECT BY ID =================
  Rx<ProjectResponse?> _projectDetails = Rx<ProjectResponse?>(null);
  ProjectResponse? get projectDetails => _projectDetails.value;

  set setProjectDetails(ProjectResponse project) {
    _projectDetails.value = project;
    likeCount.value = project.likeCount;
    comments.assignAll(project.comments);
  }

  Future<void> fetchProjectById(String projectId) async {
    setLoading = true;

    try {
      String token = box.read("token");

      Uri url = Uri.parse(getProjectDetailsUrl(projectId));

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List && decoded.isNotEmpty) {
          final p = ProjectResponse.fromJson(decoded[0]);
          _projectDetails.value = p;
          likeCount.value = p.likeCount;
          comments.assignAll(p.comments);
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('project')) {
            final p = ProjectResponse.fromJson(decoded['project']);
            _projectDetails.value = p;
            isLiked.value = decoded['isLiked'] ?? false;
            likeCount.value = p.likeCount;
            comments.assignAll(p.comments);
          } else {
            final p = ProjectResponse.fromJson(decoded);
            _projectDetails.value = p;
            likeCount.value = p.likeCount;
            comments.assignAll(p.comments);
          }
        }

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

  // ================= CLEAR PROJECTS =================
  void clearProjects() {
    _projects.clear();
  }

  // ================= GET SINGLE PROJECT =================
  ProjectModel? getProjectByIndex(int index) {
    if (index >= 0 && index < _projects.length) {
      return _projects[index];
    }
    return null;
  }

  Future<void> approveProject(String projectId) async {
    setLoading = true;

    try {
      String token = box.read("token");

      Uri url = Uri.parse(approveProjectUrl(projectId));

      var response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        Get.snackbar(
          "Success",
          data["message"] ?? "Project Approved",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );

        // 🔥 Update UI instantly (remove from pending list)
        _myProjects.removeWhere((p) => p.id == projectId);

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

  Future<void> rejectProject(String projectId) async {
    setLoading = true;

    try {
      String token = box.read("token");

      Uri url = Uri.parse(rejectProjectUrl(projectId));

      var response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        Get.snackbar(
          "Success",
          data["message"] ?? "Project Rejected",
          colorText: Colors.white,
          backgroundColor: Colors.orange,
        );

        // 🔥 Remove from pending list instantly
        _myProjects.removeWhere((p) => p.id == projectId);

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

  Rx<ProjectResponse?> _selectedProject = Rx<ProjectResponse?>(null);
  ProjectResponse? get selectedProject => _selectedProject.value;

  RxList<dynamic> comments = [].obs;
  RxInt likeCount = 0.obs;
  RxBool isLiked = false.obs;

  // 👉 FETCH COMMENTS
  Future<void> fetchComments(String projectId) async {
    String? token = box.read("token");

    try {
      setLoading = true;

      Uri url = Uri.parse("$getCommentsUrl/$projectId/comments");

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('comments')) {
          comments.assignAll(decoded['comments']);
        } else if (decoded is List) {
          comments.assignAll(decoded);
        }
      }
    } catch (e) {
      debugPrint("Fetch Comment Error: $e");
    } finally {
      setLoading = false;
    }
  }

  Future<void> addComment(String projectId, String text) async {
    String? token = box.read("token");

    Uri url = Uri.parse("$addCommentUrl/$projectId/comment");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({"text": text}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        comments.value = decoded;

        // 🔥 update selected project
        if (_selectedProject.value != null) {
          _selectedProject.update((proj) {
            proj!.comments = comments;
          });
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Comment Error: ${e.toString()}");
    }
  }

  Future<void> replyToComment(String projectId, String commentId, String text) async {
    String? token = box.read("token");

    Uri url = Uri.parse("$replyUrl/$projectId/comment/$commentId/reply");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({"text": text}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        comments.value = decoded;

        // 🔥 update selected project
        if (_selectedProject.value != null) {
          _selectedProject.update((proj) {
            proj!.comments = comments;
          });
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Reply Error: ${e.toString()}");
    }
  }

  Future<void> toggleLike(String projectId) async {
    String? token = box.read("token");

    Uri url = Uri.parse("$toggleLikeUrl/$projectId/like");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        likeCount.value = decoded['likeCount'];
        isLiked.value = decoded['liked'];

        // 🔥 update selected project
        if (_selectedProject.value != null) {
          _selectedProject.update((proj) {
            proj!.likeCount = likeCount.value;
          });
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Like Error: ${e.toString()}");
    }
  }
}

