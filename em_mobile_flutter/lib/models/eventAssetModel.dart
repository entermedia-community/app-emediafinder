class EventAssetModel {
  Response response;
  List<EventResults> results;

  EventAssetModel({this.response, this.results});

  EventAssetModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? new Response.fromJson(json['response']) : null;
    if (json['results'] != null) {
      results = new List<EventResults>();
      json['results'].forEach((v) {
        results.add(new EventResults.fromJson(v));
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

class Response {
  String status;
  int totalhits;
  String searchtype;
  int hitsperpage;
  int page;
  int pages;
  String hitsessionid;
  Query query;

  Response({this.status, this.totalhits, this.searchtype, this.hitsperpage, this.page, this.pages, this.hitsessionid, this.query});

  Response.fromJson(Map<String, dynamic> json) {
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

class EventResults {
  String id;
  String name;
  Entitysourcetype entitysourcetype;
  String entityDate;
  String hasfulltext;

  EventResults({this.id, this.name, this.entitysourcetype, this.entityDate, this.hasfulltext});

  EventResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    entitysourcetype = json['entitysourcetype'] != null ? new Entitysourcetype.fromJson(json['entitysourcetype']) : null;
    entityDate = json['entity_date'];
    hasfulltext = json['hasfulltext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.entitysourcetype != null) {
      data['entitysourcetype'] = this.entitysourcetype.toJson();
    }
    data['entity_date'] = this.entityDate;
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
