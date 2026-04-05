import 'package:admin/constants/constants.dart';
import 'package:admin/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/login_controller.dart';
import '../constats/colors.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const Sidebar({
    super.key,
    required this.onItemSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<LoginController>();

    // Detect if we're inside a Drawer (the Drawer constrains width for us)
    final isInsideDrawer = context.findAncestorWidgetOfExactType<Drawer>() != null;

    return Container(
      width: isInsideDrawer ? null : 260,
      color: Color(0xff1B4965),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    "assets/images/logo.png",
                    height: 50,
                    width: 50,
                  ),
                
                const SizedBox(width: 7),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ProjexHub Admin",
                      style: TextStyle(
                        color: kLightWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "MANAGEMENT SUITE",
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
              ],
            ),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: textGrey,thickness: 1,),
            ),
            const SizedBox(height: 30),

            menuItem(Icons.grid_view_rounded, "Dashboard", 0),
            menuItem(Icons.pending_actions, "Pending Projects", 1),
            menuItem(Icons.check_circle_outline, "Approved Projects", 2),
            menuItem(Icons.cancel_outlined, "Rejected Projects", 3),
            menuItem(Icons.people_outline, "User List", 4),
            menuItem(Icons.feedback_outlined, "Feedbacks", 5),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: (){
                  controller.logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kLightWhite,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 18, color: Color(0xff4B39EF),),
                    SizedBox(width: 8,),
                    Text("Logout", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xff4B39EF))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title, int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        onItemSelected(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF0FE) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            ListTile(
              minLeadingWidth: 20,
              leading: Icon(
                icon,
                color: isSelected ? const Color(0xff4B39EF) : kLightWhite,
                size: 22,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: isSelected ? const Color(0xff4B39EF) :kLightWhite,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                left: 0,
                top: 10,
                bottom: 10,
                child: Container(
                  width: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xff4B39EF),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}