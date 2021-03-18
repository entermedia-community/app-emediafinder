class CreateUserResponseModel {
  Response response;
  CreateUserData data;

  CreateUserResponseModel({this.response, this.data});

  CreateUserResponseModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? new Response.fromJson(json['response']) : null;
    data = json['data'] != null ? new CreateUserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Response {
  String status;
  String id;

  Response({this.status, this.id});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['id'] = this.id;
    return data;
  }
}

class CreateUserData {
  String id;
  String name;
  String enabled;
  String password;
  String creationdate;

  CreateUserData({this.id, this.name, this.enabled, this.password, this.creationdate});

  CreateUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    enabled = json['enabled'];
    password = json['password'];
    creationdate = json['creationdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['enabled'] = this.enabled;
    data['password'] = this.password;
    data['creationdate'] = this.creationdate;
    return data;
  }
}
