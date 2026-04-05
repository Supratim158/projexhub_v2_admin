
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/project_controller.dart';

class CommentSheet extends StatefulWidget {
  final String projectId;

  const CommentSheet({super.key, required this.projectId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final ProjectController controller = Get.find();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchComments(widget.projectId);
  }

  void showReplyDialog(String commentId) {
    TextEditingController replyController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey[900],
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Write Reply",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),

              TextField(
                controller: replyController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type your reply...",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Cancel",
                        style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (replyController.text.trim().isNotEmpty) {
                        controller.replyToComment(
                          widget.projectId,
                          commentId,
                          replyController.text.trim(),
                        );
                        Get.back();
                      }
                    },
                    child: Text("Send"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget commentInputBox() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write a comment...",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (commentController.text.trim().isNotEmpty) {
                controller.addComment(
                  widget.projectId,
                  commentController.text.trim(),
                );
                commentController.clear();
              }
            },
          )
        ],
      ),
    );
  }

  Widget buildCommentItem(dynamic comment) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[800],
                backgroundImage: (comment['user'] is Map &&
                    comment['user']['profile'] != null &&
                    comment['user']['profile'].toString().isNotEmpty)
                    ? NetworkImage(comment['user']['profile'])
                    : (comment['user'] is Map &&
                    comment['user']['profilePic'] != null &&
                    comment['user']['profilePic'].toString().isNotEmpty)
                    ? NetworkImage(comment['user']['profilePic'])
                    : null,
                child: (!(comment['user'] is Map) ||
                    (comment['user']['profile'] == null &&
                        comment['user']['profilePic'] == null) ||
                    (comment['user']['profile']?.toString().isEmpty ?? true) &&
                        (comment['user']['profilePic']
                            ?.toString()
                            .isEmpty ??
                            true))
                    ? Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (comment['user'] is Map)
                          ? (comment['user']['userName'] ??
                          comment['user']['name'] ??
                          "User")
                          : "User",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      comment['text'] ?? "",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 6),

                    GestureDetector(
                      onTap: () => showReplyDialog(comment['_id']),
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Reply",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Replies
          if (comment['replies'] != null)
            Padding(
              padding: EdgeInsets.only(left: 40, top: 10),
              child: Column(
                children: List.generate(
                  comment['replies'].length,
                      (i) {
                    final reply = comment['replies'][i];

                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: Colors.grey.shade800),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey[800],
                            backgroundImage: (reply['user'] is Map &&
                                reply['user']['profile'] != null &&
                                reply['user']['profile']
                                    .toString()
                                    .isNotEmpty)
                                ? NetworkImage(reply['user']['profile'])
                                : (reply['user'] is Map &&
                                reply['user']['profilePic'] != null &&
                                reply['user']['profilePic']
                                    .toString()
                                    .isNotEmpty)
                                ? NetworkImage(
                                reply['user']['profilePic'])
                                : null,
                            child: (!(reply['user'] is Map) ||
                                (reply['user']['profile'] == null &&
                                    reply['user']['profilePic'] ==
                                        null) ||
                                (reply['user']['profile']
                                    ?.toString()
                                    .isEmpty ??
                                    true) &&
                                    (reply['user']['profilePic']
                                        ?.toString()
                                        .isEmpty ??
                                        true))
                                ? Icon(Icons.person,
                                size: 12, color: Colors.white)
                                : null,
                          ),
                          SizedBox(width: 8),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (reply['user'] is Map)
                                      ? (reply['user']['userName'] ??
                                      reply['user']['name'] ??
                                      "")
                                      : "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  reply['text'] ?? "",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Comments list
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (controller.comments.isEmpty) {
                      return Center(
                        child: Text(
                          "No comments yet",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: controller.comments.length,
                      itemBuilder: (context, index) {
                        return buildCommentItem(
                          controller.comments[index],
                        );
                      },
                    );
                  }),
                ),

                // Input
                commentInputBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}