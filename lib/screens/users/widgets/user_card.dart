import 'package:admin/core/constats/colors.dart';
import 'package:admin/widgets/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controllers/login_controller.dart';

class UserCard extends StatelessWidget {
  final String username;
  final String email;
  final String imageUrl;

  const UserCard({
    super.key,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {


    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 🔹 Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 15),

            // 🔹 Title + Username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Review Button
            IconButton(onPressed: (){
              Get.defaultDialog(
                title: "Delete User",
                middleText: "Are you sure you want to delete this user?",
                textConfirm: "Yes",
                textCancel: "No",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                },
              );
            }, icon: Icon(Icons.delete, color: Colors.red,))
          ],
        ),
      ),
    );
  }
}