// To parse this JSON data, do
//
//     final feedbackResponse = feedbackResponseFromJson(jsonString);

import 'dart:convert';

FeedbackResponse feedbackResponseFromJson(String str) => FeedbackResponse.fromJson(json.decode(str));

String feedbackResponseToJson(FeedbackResponse data) => json.encode(data.toJson());

class FeedbackResponse {
    bool status;
    List<Datum> data;

    FeedbackResponse({
        required this.status,
        required this.data,
    });

    factory FeedbackResponse.fromJson(Map<String, dynamic> json) => FeedbackResponse(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    User user;
    String title;
    String feedback;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Datum({
        required this.id,
        required this.user,
        required this.title,
        required this.feedback,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        user: User.fromJson(json["user"]),
        title: json["title"],
        feedback: json["feedback"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user.toJson(),
        "title": title,
        "feedback": feedback,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class User {
    String id;
    String userName;
    String email;
    String profile;

    User({
        required this.id,
        required this.userName,
        required this.email,
        required this.profile,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        profile: json["profile"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "profile": profile,
    };
}
