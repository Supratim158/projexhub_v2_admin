import 'package:flutter/material.dart';

class CustomAdminAppbar extends StatelessWidget {
  final String adminName;
  final String pageTitle;
  final String imageUrl;

  const CustomAdminAppbar({
    super.key,
    required this.adminName,
    required this.pageTitle,
    required this.imageUrl,
  });

  /// Breakpoint must match the one in DashboardScreen
  static const double _mobileBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < _mobileBreakpoint;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xffEAF6FF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          /// Hamburger menu icon — only on mobile
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, size: 28),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),

          

          /// Right Side
          Row(
            mainAxisSize: MainAxisSize.min,
            
            children: [

              /// Notification
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Color(0xff444444)),
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),

              if (!isMobile) const SizedBox(width: 20),

              /// Admin Name (hide on mobile)
              if (!isMobile)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      adminName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      "Super Admin",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

              if (!isMobile) const SizedBox(width: 12),

              /// Profile Picture (Circle)
              ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}