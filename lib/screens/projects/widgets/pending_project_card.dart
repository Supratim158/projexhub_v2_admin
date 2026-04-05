import 'package:flutter/material.dart';

class PendingProjectCard extends StatelessWidget {
  final String title;
  final List<String> usernames;
  final List<String> imageUrls;
  final VoidCallback onReview;

  const PendingProjectCard({
    super.key,
    required this.title,
    required this.usernames,
    required this.imageUrls,
    required this.onReview,
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
            // 🔹 Show first image from list
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrls.isNotEmpty
                  ? Image.network(
                imageUrls[0],
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 80,
                width: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
            ),

            const SizedBox(width: 15),

            // 🔹 Title + Username(s)
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

                  // Show all usernames
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
            ElevatedButton(
              onPressed: onReview,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Review"),
            ),
          ],
        ),
      ),
    );
  }
}