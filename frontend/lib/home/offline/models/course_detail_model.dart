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
  String type;
  String title;
  String? category;
  String? url;
  String? applyStartDate;
  String? applyEndDate;
  String? startDate;
  String? endDate;
  int? deptId;
  String? deptName;
  String? deptGu;
  double? deptLat;
  double? deptLng;
  String? insertDate;
  int? likeCount;
  bool? isAvailable;
  bool? isFree;
  int? capacity;
  String? deptTel;
  String? deptAddr;
  bool? isLiked;

  Data({
    required this.courseId,
    required this.type,
    required this.title,
    this.category,
    this.url,
    this.applyStartDate,
    this.applyEndDate,
    this.startDate,
    this.endDate,
    this.deptId,
    this.deptName,
    this.deptGu,
    this.deptLat,
    this.deptLng,
    this.insertDate,
    this.likeCount,
    this.isAvailable,
    this.isFree,
    this.capacity,
    this.deptTel,
    this.deptAddr,
    this.isLiked,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        courseId: json["courseId"],
        type: json["type"],
        title: json["title"],
        category: json["category"],
        url: json["url"],
        applyStartDate: json["applyStartDate"] ?? "",
        applyEndDate: json["applyEndDate"] ?? "",
        startDate: json["startDate"] ?? "",
        endDate: json["endDate"] ?? "",
        deptId: json["deptId"] ?? 0,
        deptName: json["deptName"] ?? "",
        deptGu: json["deptGu"] ?? "",
        deptLat: json["deptLat"]?.toDouble() ?? 0.0,
        deptLng: json["deptLng"]?.toDouble() ?? 0.0,
        insertDate: json["insertDate"],
        likeCount: json["likeCount"] ?? 0,
        isAvailable: json["isAvailable"] ?? false,
        isFree: json["isFree"] ?? false,
        capacity: json["capacity"] ?? 0,
        deptTel: json["deptTel"] ?? "",
        deptAddr: json["deptAddr"] ?? "",
        isLiked: json["isLiked"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "type": type,
        "title": title,
        "category": category,
        "url": url,
        "applyStartDate": applyStartDate,
        "applyEndDate": applyEndDate,
        "startDate": startDate,
        "endDate": endDate,
        "deptId": deptId,
        "deptName": deptName,
        "deptGu": deptGu,
        "deptLat": deptLat,
        "deptLng": deptLng,
        "insertDate": insertDate,
        "likeCount": likeCount,
        "isAvailable": isAvailable,
        "isFree": isFree,
        "capacity": capacity,
        "deptTel": deptTel,
        "deptAddr": deptAddr,
        "isLiked": isLiked,
      };
}
