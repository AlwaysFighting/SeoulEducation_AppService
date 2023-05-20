class Writer {
  int? status;
  String? message;
  List<Model>? data;

  Writer({this.status, this.message, this.data});

  Writer.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Model>[];
      json['data'].forEach((v) {
        data!.add(new Model.fromJson(v));
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

class Model {
  int? id;
  String? title;
  String? content;
  int? userId;
  String? publishDate;
  int? viewCount;
  int? commentCount;
  String? userNickname;

  Model(
      {this.id,
        this.title,
        this.content,
        this.userId,
        this.publishDate,
        this.viewCount,
        this.commentCount,
        this.userNickname});

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    userId = json['userId'];
    publishDate = json['publishDate'];
    viewCount = json['viewCount'];
    commentCount = json['commentCount'];
    userNickname = json['userNickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['userId'] = this.userId;
    data['publishDate'] = this.publishDate;
    data['viewCount'] = this.viewCount;
    data['commentCount'] = this.commentCount;
    data['userNickname'] = this.userNickname;
    return data;
  }
}
