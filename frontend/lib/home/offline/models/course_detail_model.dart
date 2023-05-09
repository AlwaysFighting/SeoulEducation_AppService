// To parse this JSON data, do
//
//     final courseDetail = courseDetailFromJson(jsonString);

import 'dart:convert';

CourseDetail courseDetailFromJson(String str) => CourseDetail.fromJson(json.decode(str));

String courseDetailToJson(CourseDetail data) => json.encode(data.toJson());

class CourseDetail {
  int status;
  Data data;

  CourseDetail({
    required this.status,
    required this.data,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  int courseId;
  String courseCode;
  String type;
  String title;
  dynamic category;
  String url;
  DateTime applyStartDate;
  DateTime applyEndDate;
  String startDate;
  dynamic endDate;
  int deptId;
  String deptName;
  String deptGu;
  double deptLat;
  double deptLng;
  DateTime insertDate;
  int likeCount;
  bool isAvailable;
  bool isFree;
  int capacity;

  Data({
    required this.courseId,
    required this.courseCode,
    required this.type,
    required this.title,
    this.category,
    required this.url,
    required this.applyStartDate,
    required this.applyEndDate,
    required this.startDate,
    this.endDate,
    required this.deptId,
    required this.deptName,
    required this.deptGu,
    required this.deptLat,
    required this.deptLng,
    required this.insertDate,
    required this.likeCount,
    required this.isAvailable,
    required this.isFree,
    required this.capacity,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    courseId: json["courseId"],
    courseCode: json["courseCode"],
    type: json["type"],
    title: json["title"],
    category: json["category"],
    url: json["url"],
    applyStartDate: DateTime.parse(json["applyStartDate"]),
    applyEndDate: DateTime.parse(json["applyEndDate"]),
    startDate: json["startDate"],
    endDate: json["endDate"],
    deptId: json["deptId"],
    deptName: json["deptName"],
    deptGu: json["deptGu"],
    deptLat: json["deptLat"]?.toDouble(),
    deptLng: json["deptLng"]?.toDouble(),
    insertDate: DateTime.parse(json["insertDate"]),
    likeCount: json["likeCount"],
    isAvailable: json["isAvailable"],
    isFree: json["isFree"],
    capacity: json["capacity"],
  );

  Map<String, dynamic> toJson() => {
    "courseId": courseId,
    "courseCode": courseCode,
    "type": type,
    "title": title,
    "category": category,
    "url": url,
    "applyStartDate": "${applyStartDate.year.toString().padLeft(4, '0')}-${applyStartDate.month.toString().padLeft(2, '0')}-${applyStartDate.day.toString().padLeft(2, '0')}",
    "applyEndDate": "${applyEndDate.year.toString().padLeft(4, '0')}-${applyEndDate.month.toString().padLeft(2, '0')}-${applyEndDate.day.toString().padLeft(2, '0')}",
    "startDate": startDate,
    "endDate": endDate,
    "deptId": deptId,
    "deptName": deptName,
    "deptGu": deptGu,
    "deptLat": deptLat,
    "deptLng": deptLng,
    "insertDate": insertDate.toIso8601String(),
    "likeCount": likeCount,
    "isAvailable": isAvailable,
    "isFree": isFree,
    "capacity": capacity,
  };
}
