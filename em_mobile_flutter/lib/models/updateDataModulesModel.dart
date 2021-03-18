class UpdateDataModulesModel {
  Response response;
  Data data;

  UpdateDataModulesModel({this.response, this.data});

  UpdateDataModulesModel.fromJson(Map<String, dynamic> json) {
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
  String id;
  String name;
  Entitysourcetype entitysourcetype;
  String description;
  String hasfulltext;

  Data({this.id, this.name, this.entitysourcetype, this.description, this.hasfulltext});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    entitysourcetype = json['entitysourcetype'] != null ? new Entitysourcetype.fromJson(json['entitysourcetype']) : null;
    description = json['description'];
    hasfulltext = json['hasfulltext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.entitysourcetype != null) {
      data['entitysourcetype'] = this.entitysourcetype.toJson();
    }
    data['description'] = this.description;
    data['hasfulltext'] = this.hasfulltext;
    return data;
  }
}

class Entitysourcetype {
  String id;
  String name;

  Entitysourcetype({this.id, this.name});

  Entitysourcetype.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
