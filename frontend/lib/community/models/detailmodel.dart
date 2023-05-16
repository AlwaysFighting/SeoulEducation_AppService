class DetailResponse {
  int? status;
  Data? data;

  DetailResponse({this.status, this.data});

  DetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
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
  int? commentCount;

  Data(
      {this.postId,
        this.title,
        this.content,
        this.userId,
        this.userNickname,
        this.publishDate,
        this.viewCount,
      this.commentCount});

  Data.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    title = json['title'];
    content = json['content'];
    userId = json['userId'];
    userNickname = json['userNickname'];
    publishDate = json['publishDate'];
    viewCount = json['viewCount'];
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    data['title'] = title;
    data['content'] = content;
    data['userId'] = userId;
    data['userNickname'] = userNickname;
    data['publishDate'] = publishDate;
    data['viewCount'] = viewCount;
    data['commentCount'] = commentCount;
    return data;
  }
}
