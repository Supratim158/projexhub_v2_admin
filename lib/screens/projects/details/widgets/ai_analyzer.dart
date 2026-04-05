
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../controllers/ai_controller.dart';
import '../../../../widgets/reusable_text.dart';

class AIAnalyzerPage extends StatelessWidget {
  final String projectId;

  AIAnalyzerPage({super.key, required this.projectId});

  final AIController controller = Get.put(AIController());
  final TextEditingController questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Column(
          children: [



            // 🔥 HEADER
            Container(
              width: double.infinity,
              height: 70,
              child: Stack(
                children: [

                  // Background Image
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),

                  // 🔥 Bottom Fade Gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xFF000000), // match your app background
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 25)),

                        Lottie.asset(
                          "assets/images/Live chatbot.json",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),

                        SizedBox(width: 15),


                        Container(
                          height: 30,
                          width: 5,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        SizedBox(width: 5),

                        ReusableText(
                          text: "ProjexHub AI",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ).copyWith(
                            shadows: [
                            Shadow(
                            color: Colors.blueAccent.withOpacity(0.9),
                            blurRadius: 12,
                            offset: Offset(0, 0),
                            ),
                            Shadow(
                            color: Colors.blueAccent.withOpacity(0.6),
                            blurRadius: 25,
                            offset: Offset(0, 0),
                            ),
                            ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),



            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E), // Dark input background
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(AntDesign.search1,
                        color: Colors.grey.shade400, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: questionController,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ask anything about this project...",
                          hintStyle:
                          TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // ElevatedButton(
            //   onPressed: () {
            //     controller.askQuestion(
            //       projectId,
            //       questionController.text,
            //     );
            //   },
            //   child: Text("Ask AI"),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  controller.askQuestion(
                    projectId,
                    questionController.text,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C64F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Center(
                      child: ReusableText(
                        text: "Ask AI",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.normal,
                        ).copyWith(height: 1.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.getSummary(projectId);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C64F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Center(
                          child: ReusableText(
                            text: "Project Summary",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.normal,
                            ).copyWith(height: 1.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.getScore(projectId);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C64F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Center(
                          child: ReusableText(
                            text: "Project Score",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.normal,
                            ).copyWith(height: 1.6),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 7),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: const Divider(color: Colors.white),
            ),
            SizedBox(height: 7),
            ReusableText(
                text: "Result",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.normal,
                )),

            SizedBox(height: 5),

            // 🔹 RESULT
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151722),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        controller.result.value.isEmpty
                            ? "Your AI result will appear here..."
                            : controller.result.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.normal,
                        ).copyWith(height: 1.6),
                      ),
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }


}
