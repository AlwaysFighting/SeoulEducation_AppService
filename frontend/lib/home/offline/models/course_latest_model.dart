import 'dart:convert';

CourseLatest courseLatestFromJson(String str) => CourseLatest.fromJson(json.decode(str));
String courseLatestToJson(CourseLatest data) => json.encode(data.toJson());

class CourseLatest {
  int status;
  List<Datum> data;

  CourseLatest({
    required this.status,
    required this.data,
  });

  factory CourseLatest.fromJson(Map<String, dynamic> json) => CourseLatest(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String type;
  int id;
  String title;
  DateTime applyStartDate;
  DateTime applyEndDate;
  bool isFree;
  dynamic category;

  Datum({
    required this.type,
    required this.id,
    required this.title,
    required this.applyStartDate,
    required this.applyEndDate,
    required this.isFree,
    this.category,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    type: json["type"],
    id: json["id"],
    title: json["title"],
    applyStartDate: DateTime.parse(json["applyStartDate"]),
    applyEndDate: DateTime.parse(json["applyEndDate"]),
    isFree: json["isFree"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "title": title,
    "applyStartDate": "${applyStartDate.year.toString().padLeft(4, '0')}-${applyStartDate.month.toString().padLeft(2, '0')}-${applyStartDate.day.toString().padLeft(2, '0')}",
    "applyEndDate": "${applyEndDate.year.toString().padLeft(4, '0')}-${applyEndDate.month.toString().padLeft(2, '0')}-${applyEndDate.day.toString().padLeft(2, '0')}",
    "isFree": isFree,
    "category": category,
  };
}
