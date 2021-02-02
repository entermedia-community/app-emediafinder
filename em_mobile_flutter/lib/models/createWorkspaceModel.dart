class CreateWorkspaceModel {
  Response response;
  Data data;

  CreateWorkspaceModel({this.response, this.data});

  CreateWorkspaceModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? new Response.fromJson(json['response']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String organizationid;
  String instanceid;
  String instanceurl;

  Data({this.organizationid, this.instanceid, this.instanceurl});

  Data.fromJson(Map<String, dynamic> json) {
    organizationid = json['organizationid'];
    instanceid = json['instanceid'];
    instanceurl = json['instanceurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organizationid'] = this.organizationid;
    data['instanceid'] = this.instanceid;
    data['instanceurl'] = this.instanceurl;
    return data;
  }
}
