class CourseList {
  int status;
  String message;
  List<Datum> data;

  CourseList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CourseList.fromJson(Map<String, dynamic> json) => CourseList(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Type? type;
  int id;
  String title;
  String applyStartDate;
  String applyEndDate;
  dynamic isFree;
  dynamic category;
  int capacity;
  bool? isLiked;

  Datum({
    this.type,
    required this.id,
    required this.title,
    required this.applyStartDate,
    required this.applyEndDate,
    this.isFree,
    this.category,
    required this.capacity,
    this.isLiked,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: typeValues.map[json["type"]],
        id: json["id"],
        title: json["title"],
        applyStartDate: json["applyStartDate"] ?? "",
        applyEndDate: json["applyEndDate"] ?? "",
        isFree: json["isFree"],
        category: json["category"],
        capacity: json["capacity"],
        isLiked: json["isLiked"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "id": id,
        "title": title,
        "applyStartDate": applyStartDate,
        "applyEndDate": applyEndDate,
        "isFree": isFree,
        "category": category,
        "capacity": capacity,
        "isLiked": isLiked,
      };
}

enum Type { ON, OFF }

final typeValues = EnumValues({
  "off": Type.OFF,
  "on": Type.ON
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}