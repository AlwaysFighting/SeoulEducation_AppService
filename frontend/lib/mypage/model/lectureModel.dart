class lectureModel {
  int? status;
  String? message;
  List<Liked>? data;

  lectureModel({this.status, this.message, this.data});

  lectureModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Liked>[];
      json['data'].forEach((v) {
        data!.add(new Liked.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Liked {
  String? wishDate;
  int? courseId;
  String? type;
  String? title;
  String? applyStartDate;
  String? applyEndDate;
  int? isFree;
  int? category;
  int? capacity;

  Liked(
      {this.wishDate,
        this.courseId,
        this.type,
        this.title,
        this.applyStartDate,
        this.applyEndDate,
        this.isFree,
        this.category,
        this.capacity});

  Liked.fromJson(Map<String, dynamic> json) {
    wishDate = json['wishDate'];
    courseId = json['courseId'];
    type = json['type'];
    title = json['title'];
    applyStartDate = json['applyStartDate'];
    applyEndDate = json['applyEndDate'];
    isFree = json['isFree'];
    category = json['category'];
    capacity = json['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wishDate'] = this.wishDate;
    data['courseId'] = this.courseId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['applyStartDate'] = this.applyStartDate;
    data['applyEndDate'] = this.applyEndDate;
    data['isFree'] = this.isFree;
    data['category'] = this.category;
    data['capacity'] = this.capacity;
    return data;
  }
}
