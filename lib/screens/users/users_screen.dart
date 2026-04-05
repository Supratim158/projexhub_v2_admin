import 'package:admin/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../auth/login_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<LoginController>();
    final box = GetStorage();

    String? token = box.read('token');

    if (token == null) {
      return LoginScreen();
    }

    // Fetch once
    userController.fetchUsers();

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Admin > User Management",
                      style: TextStyle(
                        color: Color(0xff4B39EF),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Active Members",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Manage platform access, roles, and user permissions across ProjexHub.",
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
                    /// FILTERS BAR
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF3F4F6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Text("All Members", style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Obx(() {
                            final totalItems = userController.users.length;
                            int startItem = totalItems == 0 ? 0 : ((currentPage - 1) * itemsPerPage) + 1;
                            int endItem = (currentPage * itemsPerPage) > totalItems ? totalItems : (currentPage * itemsPerPage);
                            return Text("Showing $startItem-$endItem of $totalItems users", style: const TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic));
                          }),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xffE5E7EB)),

                    /// TABLE HEADER
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: const [
                          Expanded(flex: 3, child: Text("PROFILE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                          Expanded(flex: 3, child: Text("EMAIL ADDRESS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                          Expanded(flex: 2, child: Text("ROLE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                          Expanded(flex: 2, child: Text("JOINED DATE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                          Expanded(flex: 1, child: Text("ACTIONS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xffE5E7EB)),

                    /// TABLE DATA
                    Expanded(
                      child: Obx(() {
                        final allUsers = userController.users;

                        if (allUsers.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        int totalPages = (allUsers.length / itemsPerPage).ceil();
                        if (totalPages == 0) totalPages = 1;
                        if (currentPage > totalPages) currentPage = totalPages;

                        final displayedUsers = allUsers
                            .skip((currentPage - 1) * itemsPerPage)
                            .take(itemsPerPage)
                            .toList();

                        return ListView.separated(
                          itemCount: displayedUsers.length,
                          separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xffE5E7EB)),
                          itemBuilder: (context, index) {
                            final user = displayedUsers[index];

                            String name = (user.userName.isNotEmpty) ? user.userName : "Unknown User";
                            String email = (user.email.isNotEmpty) ? user.email : "No Email";
                            String role = (user.userType.isNotEmpty) ? user.role : "STANDARD USER";
                            DateTime date = user.createdAt;
                            String formattedDate = DateFormat('MMM dd, yyyy').format(date);
                            String formattedTime = DateFormat('hh:mm a').format(date);
                            String id = user.id.isNotEmpty ? "#PH-${user.id.substring(0, user.id.length > 4 ? 4 : user.id.length)}" : "#PH-0000";
                            String profileUrl = user.profile ?? "";

                            // Determine role colors
                            Color badgeBg;
                            Color badgeText;
                            if (role == "ADMIN" || role == "ADMINISTRATOR") {
                              badgeBg = const Color(0xffEEF2FF);
                              badgeText = const Color(0xff4B39EF);
                            } else if (role == "EDITOR") {
                              badgeBg = const Color(0xffECFDF5);
                              badgeText = const Color(0xff059669);
                            } else {
                              badgeBg = const Color(0xffF5F3FF);
                              badgeText = const Color(0xff7C3AED);
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                              child: Row(
                                children: [
                                  // PROFILE
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey.shade300,
                                          backgroundImage: profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null,
                                          child: profileUrl.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87), overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Text("ID: $id", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // EMAIL ADDRESS
                                  Expanded(
                                    flex: 3,
                                    child: Text(email, style: const TextStyle(color: Colors.black54, fontSize: 13), overflow: TextOverflow.ellipsis),
                                  ),

                                  // ROLE
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(12)),
                                          child: SizedBox(
                                            width: 80, // 🔥 required to trigger ellipsis
                                            child: Text(
                                              role,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: TextStyle(
                                                color: badgeText,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                  ),

                                  // JOINED DATE (Mocked since user model lacks it)
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

                                  // ACTIONS
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: const [
                                        Icon(Icons.remove_red_eye, color: Colors.black54, size: 18),
                                        SizedBox(width: 16),
                                        Icon(Icons.block, color: Colors.black54, size: 18),
                                        SizedBox(width: 16),
                                        Icon(Icons.delete, color: Colors.black54, size: 18),
                                      ],
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
                        final totalItems = userController.users.length;
                        int totalPages = (totalItems / itemsPerPage).ceil();
                        if (totalPages == 0) totalPages = 1;
                        
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: currentPage > 1 ? () => setState(() => currentPage--) : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: currentPage > 1 ? Colors.grey.shade300 : Colors.grey.shade200), 
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Row(children: [Icon(Icons.arrow_back, size: 16, color: currentPage > 1 ? Colors.black87 : Colors.grey), const SizedBox(width: 8), Text("Previous", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: currentPage > 1 ? Colors.black87 : Colors.grey))]),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 32, height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: const Color(0xff4B39EF), borderRadius: BorderRadius.circular(6)),
                                  child: Text("$currentPage", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                const Text("of", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Text("$totalPages", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            GestureDetector(
                              onTap: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: currentPage < totalPages ? Colors.grey.shade300 : Colors.grey.shade200), 
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Row(children: [Text("Next", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: currentPage < totalPages ? Colors.black87 : Colors.grey)), const SizedBox(width: 8), Icon(Icons.arrow_forward, size: 16, color: currentPage < totalPages ? Colors.black87 : Colors.grey)]),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            
          ],
        ),
      ),
    );
  }
}
