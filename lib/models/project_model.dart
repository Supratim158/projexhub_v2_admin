// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

ProjectModel projectModelFromJson(String str) => ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  String title;
  String tagline;
  String description;
  List<String> images;
  String video;
  String projectReportPdf;
  String projectPptPdf;
  List<String> technologies;
  String repoLink;
  String demoLink;
  int memberSize;
  String duration;
  List<String> memberNames;
  List<String> memberIds;
  List<String> categories;
  String? status;

  ProjectModel({
    required this.title,
    required this.tagline,
    required this.description,
    required this.images,
    required this.video,
    required this.projectReportPdf,
    required this.projectPptPdf,
    required this.technologies,
    required this.repoLink,
    required this.demoLink,
    required this.memberSize,
    required this.memberIds,
    required this.duration,
    required this.memberNames,
    this.status,
    required this.categories,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    title: json["title"],
    tagline: json["tagline"],
    description: json["description"],
    images: List<String>.from(json["images"].map((x) => x)),
    video: json["video"],
    projectReportPdf: json["projectReportPdf"],
    projectPptPdf: json["projectPptPdf"],
    technologies: List<String>.from(json["technologies"].map((x) => x)),
    repoLink: json["repoLink"],
    demoLink: json["demoLink"],
    memberSize: json["memberSize"],
    duration: json["duration"],
    memberNames: List<String>.from(json["memberNames"].map((x) => x)),
    categories: List<String>.from(json["categories"].map((x) => x)),
    status: json["status"],
    memberIds: List<String>.from(json["memberIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "tagline": tagline,
    "description": description,
    "images": List<dynamic>.from(images.map((x) => x)),
    "video": video,
    "projectReportPdf": projectReportPdf,
    "projectPptPdf": projectPptPdf,
    "technologies": List<dynamic>.from(technologies.map((x) => x)),
    "repoLink": repoLink,
    "demoLink": demoLink,
    "memberSize": memberSize,
    "duration": duration,
    "memberNames": List<dynamic>.from(memberNames.map((x) => x)),
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "status": status,
    "memberIds": List<dynamic>.from(memberIds.map((x) => x)),
  };
}
