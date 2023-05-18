
class postlist {
  int? status;
  String? message;
  List<Data>? data;

  postlist({this.status, this.message, this.data});

  postlist.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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
