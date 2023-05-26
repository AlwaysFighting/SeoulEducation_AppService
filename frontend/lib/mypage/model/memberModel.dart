class memberModel {
  int? status;
  Member? data;

  memberModel({this.status, this.data});

  memberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Member.fromJson(json['data']) : null;
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

class Member {
  String? email;
  String? nickname;

  Member({this.email, this.nickname});

  Member.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['nickname'] = this.nickname;
    return data;
  }
}
