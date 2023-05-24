class Alarm {
  int status;
  String message;
  List<Datum> data;

  Alarm({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
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
  int? notifyId;
  String? category;
  bool? isChecked;
  String? publishDate;
  dynamic courseId;
  int? postId;
  int? commentId;
  String? type;

  Datum({
    this.notifyId,
    this.category,
    this.isChecked,
    this.publishDate,
    this.courseId,
    this.postId,
    this.commentId,
    this.type,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    notifyId: json["notifyId"],
    category: json["category"],
    isChecked: json["isChecked"],
    publishDate:json["publishDate"],
    courseId: json["courseId"],
    postId: json["postId"],
    commentId: json["commentId"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "notifyId": notifyId,
    "category": category,
    "isChecked": isChecked,
    "publishDate": publishDate,
    "courseId": courseId,
    "postId": postId,
    "commentId": commentId,
    "type": type,
  };
}