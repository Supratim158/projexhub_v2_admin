// To parse this JSON data, do
//
//     final projectResponse = projectResponseFromJson(jsonString);

import 'dart:convert';

ProjectResponse projectResponseFromJson(String str) => ProjectResponse.fromJson(json.decode(str));

String projectResponseToJson(ProjectResponse data) => json.encode(data.toJson());

class ProjectResponse {
  String userId;
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
  String status;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<String> categories;
  int likeCount;
  List comments;
  

  ProjectResponse({
    required this.userId,
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
    required this.duration,
    required this.memberNames,
    required this.memberIds,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.categories,
    required this.likeCount,
    required this.comments,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) => ProjectResponse(
    userId: json["userId"] != null 
        ? (json["userId"] is Map ? json["userId"]["_id"].toString() : json["userId"].toString()) 
        : "",
    title: json["title"] ?? "",
    tagline: json["tagline"] ?? "",
    description: json["description"] ?? "",
    images: json["images"] != null 
        ? List<String>.from(json["images"].map((x) => x is Map ? (x["url"] ?? x["secure_url"] ?? x.toString()) : x.toString())) 
        : [],
    video: json["video"] ?? "",
    projectReportPdf: json["projectReportPdf"] ?? "",
    projectPptPdf: json["projectPptPdf"] ?? "",
    technologies: json["technologies"] != null ? List<String>.from(json["technologies"].map((x) => x.toString())) : [],
    repoLink: json["repoLink"] ?? "",
    demoLink: json["demoLink"] ?? "",
    memberSize: json["memberSize"] ?? 0,
    duration: json["duration"] ?? "",
    memberNames: json["memberNames"] != null ? List<String>.from(json["memberNames"].map((x) => x.toString())) : [],
    memberIds: json["memberIds"] != null ? List<String>.from(json["memberIds"].map((x) => x.toString())) : [],
    status: json["status"] != null ? json["status"].toString().toLowerCase() : "",
    id: json["_id"] ?? "",
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
    updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : DateTime.now(),
    v: json["__v"] ?? 0,
    categories: json["categories"] != null ? List<String>.from(json["categories"].map((x) => x.toString())) : [],
    likeCount: json['likeCount'] ?? 0,
    comments: json['comments'] ?? [],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
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
    "memberIds": List<dynamic>.from(memberIds.map((x) => x)),
    "status": status,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "likeCount": likeCount,
    "comments": comments,
  };
}
