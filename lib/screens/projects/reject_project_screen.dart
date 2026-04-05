import 'package:admin/screens/projects/details/project_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../controllers/project_controller.dart';
import '../auth/login_screen.dart';

class RejectProjectScreen extends StatefulWidget {
  const RejectProjectScreen({super.key});

  @override
  State<RejectProjectScreen> createState() => _RejectProjectScreenState();
}

class _RejectProjectScreenState extends State<RejectProjectScreen> {
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final projectController = Get.find<ProjectController>();
    final box = GetStorage();

    String? token = box.read('token');

    if (token == null) {
      return LoginScreen();
    }

    // Fetch once
    projectController.fetchRejectedProjects();

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rejected Projects",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Review and manage rejected project submissions.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// TABLE AREA
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    /// TABLE HEADER
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: Text("PROJECT TITLE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                          Expanded(flex: 2, child: Text("SUBMITTED BY", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                          Expanded(flex: 2, child: Text("SUBMISSION DATE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                          Expanded(flex: 1, child: Text("STATUS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                          Expanded(flex: 1, child: Center(child: Text("DETAILS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)))),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xffE5E7EB)),

                    /// TABLE DATA
                    Expanded(
                      child: Obx(() {
                        final projects = projectController.myProjects;

                        if (projects.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        int totalPages = (projects.length / itemsPerPage).ceil();
                        if (totalPages == 0) totalPages = 1;
                        if (currentPage > totalPages) currentPage = totalPages;

                        final displayedProjects = projects
                            .skip((currentPage - 1) * itemsPerPage)
                            .take(itemsPerPage)
                            .toList();

                        return ListView.separated(
                          itemCount: displayedProjects.length,
                          separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xffE5E7EB)),
                          itemBuilder: (context, index) {
                            final project = displayedProjects[index];

                            // Safe extracters
                            String title = project.title.isNotEmpty ? project.title : "Untitled Request";
                            String id = project.id.isNotEmpty ? "PRJ-${project.id.substring(0, project.id.length > 5 ? 5 : project.id.length)}" : "PRJ-00000";
                            String memberName = project.memberNames.isNotEmpty ? project.memberNames.first : "Unknown User";
                            DateTime date = project.createdAt;
                            String formattedDate = DateFormat('MMM dd, yyyy').format(date);
                            String formattedTime = DateFormat('hh:mm a').format(date);

                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  // PROJECT TITLE
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(color: const Color(0xffFEF2F2), borderRadius: BorderRadius.circular(8)),
                                          child: const Icon(Icons.architecture, color: Color(0xffEF4444)),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87), overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Text("ID: $id", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // SUBMITTED BY
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.person, size: 14, color: Colors.white),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(memberName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87), overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // SUBMISSION DATE
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                                        const SizedBox(height: 4),
                                        Text(formattedTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                  ),

                                  // STATUS
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(color: const Color(0xffFEF2F2), borderRadius: BorderRadius.circular(12)),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.circle, color: Color(0xffEF4444), size: 6),
                                              SizedBox(width: 6),
                                              Text("Rejected", style: TextStyle(color: Color(0xffEF4444), fontWeight: FontWeight.bold, fontSize: 11)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // DETAILS
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color(0xffF3F4F6),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                        onPressed: () {
                                          projectController.setProjectDetails = project;
                                          Get.to(() => const ProjectDetails());
                                        },
                                        child: const Text("Details", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    /// PAGINATION FOOTER
                    const Divider(height: 1, color: Color(0xffE5E7EB)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Obx(() {
                        final totalItems = projectController.myProjects.length;
                        int totalPages = (totalItems / itemsPerPage).ceil();
                        if (totalPages == 0) totalPages = 1;
                        
                        int startItem = totalItems == 0 ? 0 : ((currentPage - 1) * itemsPerPage) + 1;
                        int endItem = (currentPage * itemsPerPage) > totalItems ? totalItems : (currentPage * itemsPerPage);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Showing $startItem-$endItem of $totalItems rejected projects", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null, 
                                  icon: Icon(Icons.chevron_left, color: currentPage > 1 ? Colors.black87 : Colors.grey)
                                ),
                                Container(
                                  width: 32, height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: const Color(0xff4B39EF), borderRadius: BorderRadius.circular(6)),
                                  child: Text("$currentPage", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                Text("of $totalPages", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null, 
                                  icon: Icon(Icons.chevron_right, color: currentPage < totalPages ? Colors.black87 : Colors.grey)
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
