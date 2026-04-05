import 'package:admin/screens/projects/reject_project_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constats/colors.dart';
import '../../core/widgets/sidebar.dart';
import '../projects/approve_projects_screen.dart';
import '../projects/pending_project_screen.dart';
import '../users/users_screen.dart';
import '../feedback/feedback_screen.dart';
import '../settings/settings_screen.dart';
import 'dashboard_home.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = [
    const DashboardHome(),
    const PendingProjectsScreen(),
    const ApprovedProjectsScreen(),
    const RejectProjectScreen(),
    const UsersScreen(),
    const FeedbackScreen(),
    const SettingsScreen(),
  ];

  /// Breakpoint: below this width the sidebar becomes a drawer
  static const double _mobileBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < _mobileBreakpoint;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
      
        /// Drawer only exists on mobile
        drawer: isMobile
            ? Drawer(
                backgroundColor: AppColors.darkBlue,
                child: Sidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                    // Close the drawer after selection
                    Navigator.of(context).pop();
                  },
                ),
              )
            : null,
      
        body: Row(
          children: [
      
            /// Permanent sidebar on desktop / tablet
            if (!isMobile)
              Sidebar(
                selectedIndex: selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
      
            /// Main content area
            Expanded(
              child: Container(
                color: AppColors.background,
                child: pages[selectedIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}