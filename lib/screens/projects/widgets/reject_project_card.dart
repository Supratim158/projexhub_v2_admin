import 'package:admin/core/constats/colors.dart';
import 'package:admin/widgets/reusable_text.dart';
import 'package:flutter/material.dart';

class RejectProjectCard extends StatelessWidget {
  final String title;
  final List<String> usernames;
  final List<String> imageUrls;

  const RejectProjectCard({
    super.key,
    required this.title,
    required this.usernames,
    required this.imageUrls,
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
                imageUrls[0],
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
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "By: ${usernames.join(', ')}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Review Button
            Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.card4,
              ),
              child: Center(
                child: ReusableText(text: "Rejected", style: TextStyle(fontSize: 16, color: AppColors.textWhite)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}