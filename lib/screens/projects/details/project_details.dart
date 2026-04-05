import 'package:admin/controllers/project_controller.dart';
import 'package:admin/screens/auth/login_screen.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/projects/details/widgets/ai_analyzer.dart';
import 'package:admin/screens/projects/details/widgets/comment_sheet.dart';
import 'package:admin/screens/projects/details/widgets/project_detailed_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({super.key});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  late final ProjectController projectController;
  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    projectController = Get.find<ProjectController>();

    // Fetch full details once using the already-set project
    final project = projectController.projectDetails;
    if (project != null && !_hasFetched) {
      _hasFetched = true;
      projectController.fetchProjectById(project.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');

    if (token == null) {
      return LoginScreen();
    }

    return Obx(() {
      final details = projectController.projectDetails;

      if (details == null) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Get.off(() => DashboardScreen());
              },
            ),
            title: Text("Project Details"),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Get.off(() => DashboardScreen());
            },
          ),
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              titleSpacing: 16,
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Project Details",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Details of the project",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        body: ProjectDetailedCard(
          title: details.title,
          usernames: details.memberNames,
          memberIds: details.memberIds,
          imageUrls: details.images,
          tagline: details.tagline,
          description: details.description,
          totalMembers: details.memberSize.toString(),
          duration: details.duration,
          link: details.repoLink,
          demoLink: details.demoLink,
          video: details.video,
          pdf: details.projectReportPdf,
          ppt: details.projectPptPdf,
          techStack: details.technologies,
          categories: details.categories,
          status: details.status,
          onApprove: () {
            projectController.approveProject(details.id);
            Get.off(() => DashboardScreen());
          },
          onReject: () {
            projectController.rejectProject(details.id);
            Get.off(() => DashboardScreen());
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// 🔥 LIKE & COMMENT BOX
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF151722),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 1,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  /// 👍 LIKE
                  IconButton(
                    icon: Icon(
                      projectController.isLiked.value
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    onPressed: () =>
                        projectController.toggleLike(details.id),
                  ),
                  Text(
                    "${projectController.likeCount.value} Stars",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  SizedBox(height: 12),

                  /// 💬 COMMENT
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            CommentSheet(projectId: details.id),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            color: Colors.white, size: 22),
                        SizedBox(height: 4),
                        Text(
                          "${projectController.comments.length} Comments",
                          style:
                              TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// 🤖 AI BUTTON
            GestureDetector(
              onTap: () {
                Get.to(() => AIAnalyzerPage(
                      projectId: details.id,
                    ));
              },
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

