class DetailResponse {
  int? status;
  Data? data;

  DetailResponse({this.status, this.data});

  DetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? postId;
  String? title;
  String? content;
  int? userId;
  String? userNickname;
  String? publishDate;
  int? viewCount;

  Data(
      {this.postId,
        this.title,
        this.content,
        this.userId,
        this.userNickname,
        this.publishDate,
        this.viewCount});

  Data.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    title = json['title'];
    content = json['content'];
    userId = json['userId'];
    userNickname = json['userNickname'];
    publishDate = json['publishDate'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['userId'] = this.userId;
    data['userNickname'] = this.userNickname;
    data['publishDate'] = this.publishDate;
    data['viewCount'] = this.viewCount;
    return data;
  }
}
