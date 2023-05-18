class replylist {
  int? status;
  String? message;
  List<replyData>? data;

  replylist({this.status, this.message, this.data});

  replylist.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <replyData>[];
      json['data'].forEach((v) {
        data!.add(replyData.fromJson(v));
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

class replyData {
  int? commentId;
  int? userId;
  String? userNickname;
  String? publishDate;
  String? content;
  List<Reply>? reply;

  replyData(
      {this.commentId,
        this.userId,
        this.userNickname,
        this.publishDate,
        this.content,
        this.reply});

  replyData.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    userId = json['userId'];
    userNickname = json['userNickname'];
    publishDate = json['publishDate'];
    content = json['content'];
    if (json['reply'] != null) {
      reply = <Reply>[];
      json['reply'].forEach((v) {
        reply!.add(Reply.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commentId'] = commentId;
    data['userId'] = userId;
    data['userNickname'] = userNickname;
    data['publishDate'] = publishDate;
    data['content'] = content;
    if (reply != null) {
      data['reply'] = reply!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reply {
  int? replyId;
  int? userId;
  String? userNickname;
  String? publishDate;
  String? content;

  Reply(
      {this.replyId,
        this.userId,
        this.userNickname,
        this.publishDate,
        this.content});

  Reply.fromJson(Map<String, dynamic> json) {
    replyId = json['replyId'];
    userId = json['userId'];
    userNickname = json['userNickname'];
    publishDate = json['publishDate'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['replyId'] = replyId;
    data['userId'] = userId;
    data['userNickname'] = userNickname;
    data['publishDate'] = publishDate;
    data['content'] = content;
    return data;
  }
}
