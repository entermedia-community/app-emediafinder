class ModuleAssetModel {
  ModuleResponse response;
  List<ModuleResults> results;

  ModuleAssetModel({this.response, this.results});

  ModuleAssetModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? new ModuleResponse.fromJson(json['response']) : null;
    if (json['results'] != null) {
      results = <ModuleResults>[];
      json['results'].forEach((v) {
        results.add(new ModuleResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModuleResponse {
  String status;
  int totalhits;
  String searchtype;
  int hitsperpage;
  int page;
  int pages;
  String hitsessionid;
  Query query;

  ModuleResponse({this.status, this.totalhits, this.searchtype, this.hitsperpage, this.page, this.pages, this.hitsessionid, this.query});

  ModuleResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalhits = json['totalhits'];
    searchtype = json['searchtype'];
    hitsperpage = json['hitsperpage'];
    page = json['page'];
    pages = json['pages'];
    hitsessionid = json['hitsessionid'];
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalhits'] = this.totalhits;
    data['searchtype'] = this.searchtype;
    data['hitsperpage'] = this.hitsperpage;
    data['page'] = this.page;
    data['pages'] = this.pages;
    data['hitsessionid'] = this.hitsessionid;
    if (this.query != null) {
      data['query'] = this.query.toJson();
    }
    return data;
  }
}

class Query {
  String friendly;
  String search;

  Query({this.friendly, this.search});

  Query.fromJson(Map<String, dynamic> json) {
    friendly = json['friendly'];
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['friendly'] = this.friendly;
    data['search'] = this.search;
    return data;
  }
}

class ModuleResults {
  String id;
  String name;
  String email;
  ModuleResults({this.id, this.name, this.email});

  ModuleResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;

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
