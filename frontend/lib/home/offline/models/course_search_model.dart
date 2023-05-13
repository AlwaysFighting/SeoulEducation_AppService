class SearchCourse {
  int status;
  String message;
  List<Datum>? data;

  SearchCourse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SearchCourse.fromJson(Map<String, dynamic> json) => SearchCourse(
    status: json["status"],
    message: json["message"],
    data: json["data"] != null
        ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
        : null,
  );


  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
  };
}

class Datum {
  Type? type;
  int? id;
  String? title;
  String? applyStartDate;
  String? applyEndDate;
  dynamic isFree;
  dynamic category;
  int? capacity;

  Datum({
    this.type,
    this.id,
    this.title,
    this.applyStartDate,
    this.applyEndDate,
    this.isFree,
    this.category,
    this.capacity,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    type: typeValues.map[json["type"]],
    id: json["id"],
    title: json["title"],
    applyStartDate: json["applyStartDate"],
    applyEndDate: json["applyEndDate"],
    isFree: json["isFree"],
    category: json["category"],
    capacity: json["capacity"],
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
  };
}

enum Type { OFF }

final typeValues = EnumValues({
  "off": Type.OFF
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
