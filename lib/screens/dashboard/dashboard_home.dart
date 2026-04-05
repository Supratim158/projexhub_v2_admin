import 'package:admin/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';
import '../../controllers/login_controller.dart';
import '../../controllers/project_controller.dart';
import '../../core/widgets/custom_appbar.dart';
import '../../core/widgets/dashboard_card.dart';
import '../../models/login_response.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  /// Breakpoint must match the one in DashboardScreen
  static const double _mobileBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final pController = Get.find<ProjectController>();

    LoginResponse? user;

    final box = GetStorage();

    String? token = box.read('token');

    if(token != null){
      user = controller.getUserInfo();
    }

    if(token == null){
      return LoginScreen();
    }

    // Trigger dashboard data fetching
    pController.fetchDashboardStats();
    controller.fetchUsers();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < _mobileBreakpoint;

    return Column(
      children: [

        /// CUSTOM APPBAR
        CustomAdminAppbar(
          pageTitle: "Admin Dashboard",
          adminName: user!.userName ?? "Username",
          imageUrl: user!.profile ?? "https://via.placeholder.com/150",
        ),

        /// BODY
        Expanded(
          child: Container(
            color: const Color(0xffF5F6FA),

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  /// OVERVIEW HEADER
                  _buildOverviewHeader(isMobile),

                  const SizedBox(height: 24),

                  /// TOP STAT CARDS
                  _buildStatCards(isMobile, pController, controller),

                  const SizedBox(height: 30),

                  /// MIDDLE SECTION
                  _buildMiddleSection(isMobile, pController),

                  const SizedBox(height: 30),

                  
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(String text, {Color color = const Color(0xFFF0FDF4), Color textColor = const Color(0xFF16A34A), IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 12, color: textColor),
          if (icon != null) const SizedBox(width: 4),
          Text(text, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOverviewHeader(bool isMobile) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Overview", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 4),
            Text("Welcome back, here's what's happening today.", style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCards(bool isMobile, ProjectController pController, LoginController lController) {
    return Obx(() {
      final cards = [
        DashboardCard(
          title: "Total Projects",
          value: "${pController.totalProjectsCount.value}",
          icon: Icons.folder,
          iconColor: const Color(0xff4B39EF),
          iconBgColor: const Color(0xffEEF2FF),
          badge: _badge("~ +12%", color: const Color(0xffEEF2FF), textColor: const Color(0xff4B39EF), icon: Icons.trending_up),
        ),
        DashboardCard(
          title: "Pending",
          value: "${pController.pendingProjectsCount.value}",
          icon: Icons.hourglass_empty,
          iconColor: const Color(0xff8B5CF6),
          iconBgColor: const Color(0xffF5F3FF),
          badge: _badge("Stable", color: const Color(0xffF3F4F6), textColor: const Color(0xff4B5563)),
        ),
        DashboardCard(
          title: "Approved",
          value: "${pController.approvedProjectsCount.value}",
          icon: Icons.verified,
          iconColor: const Color(0xff0EA5E9),
          iconBgColor: const Color(0xffF0F9FF),
          badge: _badge("~ +8%", color: const Color(0xffF0FDF4), textColor: const Color(0xff16A34A), icon: Icons.trending_up),
        ),
        DashboardCard(
          title: "Rejected",
          value: "${pController.rejectedProjectsCount.value}",
          icon: Icons.cancel,
          iconColor: const Color(0xffEF4444),
          iconBgColor: const Color(0xffFEF2F2),
          badge: _badge("~ -2%", color: const Color(0xffFEF2F2), textColor: const Color(0xffEF4444), icon: Icons.trending_down),
        ),
        DashboardCard(
          title: "Total Users",
          value: "${lController.users.length}",
          icon: Icons.people,
          iconColor: const Color(0xff3B82F6),
          iconBgColor: const Color(0xffEFF6FF),
          badge: _badge("Active", color: const Color(0xffF0FDF4), textColor: const Color(0xff16A34A), icon: Icons.bolt),
        ),
      ];

      if (isMobile) {
        return Column(
          children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 16), child: SizedBox(width: double.infinity, child: c))).toList(),
        );
      }

      return LayoutBuilder(
  builder: (context, constraints) {
    int crossAxisCount = 5;

    if (constraints.maxWidth < 1200) {
      crossAxisCount = 3;
    }
    if (constraints.maxWidth < 800) {
      crossAxisCount = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 176,
      ),
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  },
);
    });
  }

  Widget _buildMiddleSection(bool isMobile, ProjectController pController) {
    final barChart = Obx(() {
      int maxVal = pController.monthlySubmissions.reduce(max);
      if (maxVal == 0) maxVal = 1;
      final scale = 200.0 / maxVal;
      
      final currentYear = DateTime.now().year.toString();
      
      return Container(
        height: 340,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Project Submissions by Month", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Tracking high-volume submission trends", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xff1B4965), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(currentYear, style: const TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Y-AXIS
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(maxVal.toString(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                            Text((maxVal ~/ 2).toString(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                            const Text("0", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(" ", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), // Spacing sync with month labels
                    ],
                  ),
                  const SizedBox(width: 16),
                  
                  /// BAR CHART
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBarMock("JAN", pController.monthlySubmissions[0] * scale),
                        _buildBarMock("FEB", pController.monthlySubmissions[1] * scale),
                        _buildBarMock("MAR", pController.monthlySubmissions[2] * scale),
                        _buildBarMock("APR", pController.monthlySubmissions[3] * scale),
                        _buildBarMock("MAY", pController.monthlySubmissions[4] * scale),
                        _buildBarMock("JUN", pController.monthlySubmissions[5] * scale),
                        _buildBarMock("JUL", pController.monthlySubmissions[6] * scale),
                        _buildBarMock("AUG", pController.monthlySubmissions[7] * scale),
                        _buildBarMock("SEP", pController.monthlySubmissions[8] * scale),
                        _buildBarMock("OCT", pController.monthlySubmissions[9] * scale),
                        _buildBarMock("NOV", pController.monthlySubmissions[10] * scale),
                        _buildBarMock("DEC", pController.monthlySubmissions[11] * scale),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });

    if (isMobile) {
      return Column(children: [barChart, const SizedBox(height: 20)]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: barChart),
        const SizedBox(width: 24),
      ],
    );
  }

  Widget _buildBarMock(String label, double value) {
    // Ensuring rendering safety so it never drops below a 4px minimum box if value is tiny but > 0
    double renderValue = (value > 0 && value < 4) ? 4.0 : value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(width: 32, height: renderValue, decoration: const BoxDecoration(color: Color(0xff1B4965), borderRadius: BorderRadius.vertical(top: Radius.circular(6)))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

}