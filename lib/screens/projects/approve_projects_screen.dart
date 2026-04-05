import 'package:admin/screens/projects/details/project_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/project_controller.dart';
import '../auth/login_screen.dart';

class ApprovedProjectsScreen extends StatefulWidget {
  const ApprovedProjectsScreen({super.key});

  @override
  State<ApprovedProjectsScreen> createState() => _ApprovedProjectsScreenState();
}

class _ApprovedProjectsScreenState extends State<ApprovedProjectsScreen> {
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
    projectController.fetchApprovedProjects();

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
                      "Approved Projects",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Reviewing successfully vetted initiatives currently active in the ecosystem.",
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

            /// GRID AREA
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

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 380,
                    mainAxisExtent: 360,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: displayedProjects.length,
                  itemBuilder: (context, index) {
                    final project = displayedProjects[index];

                    // Extract data safe
                    String title = project.title.isNotEmpty ? project.title : "Untitled Project";
                    String description = project.description.isNotEmpty ? project.description : (project.tagline.isNotEmpty ? project.tagline : "No description available.");
                    String image = project.images.isNotEmpty ? project.images.first : "";
                    List<String> names = project.memberNames;

                    // Compute Member Names
                    String membersDisplay = "No members listed";
                    if (names.isNotEmpty) {
                      if (names.length <= 4) {
                        membersDisplay = names.join(", ");
                      } else {
                        membersDisplay = "${names.take(4).join(", ")} +${names.length - 4} more";
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        projectController.setProjectDetails = project;
                        Get.to(() => const ProjectDetails());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TOP IMAGE
                            Expanded(
                              flex: 3,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Container(
                                      width: double.infinity,
                                      color: const Color(0xff1E293B),
                                      child: image.isNotEmpty
                                          ? Image.network(image, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.broken_image, color: Colors.white54, size: 40))
                                          : const Center(child: Icon(Icons.image, color: Colors.white24, size: 40)),
                                    ),
                                  ),
                                  // APPROVED BADGE
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.circle, color: Color(0xff10B981), size: 6),
                                          SizedBox(width: 4),
                                          Text("APPROVED", style: TextStyle(color: Color(0xff065F46), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// MIDDLE CONTENT
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_outward, color: Colors.black87, size: 18),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      description,
                                      style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// BOTTOM AVATAR ROW
                            const Divider(height: 1, color: Color(0xffF3F4F6)),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Color(0xffE5E7EB),
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          names.isNotEmpty ? names.first : "Unknown",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          membersDisplay,
                                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Mock arbitrary badge
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffEEF2FF),
                                    ),
                                    child: const Icon(Icons.verified, color: Color(0xff4B39EF), size: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            /// PAGINATION FOOTER
            const Divider(height: 1, color: Color(0xffE5E7EB)),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Obx(() {
                final totalItems = projectController.myProjects.length;
                int totalPages = (totalItems / itemsPerPage).ceil();
                if (totalPages == 0) totalPages = 1;
                
                int startItem = totalItems == 0 ? 0 : ((currentPage - 1) * itemsPerPage) + 1;
                int endItem = (currentPage * itemsPerPage) > totalItems ? totalItems : (currentPage * itemsPerPage);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Showing $startItem-$endItem of $totalItems projects", style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
    );
  }

  Widget _buildCategoryTab(String title, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? const Color(0xff4B39EF) : Colors.grey.shade600,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}