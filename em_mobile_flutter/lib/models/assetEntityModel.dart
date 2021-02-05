class AssetEntityModel {
  Response response;
  List<MediaResults> results;

  AssetEntityModel({this.response, this.results});

  AssetEntityModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? new Response.fromJson(json['response']) : null;
    if (json['results'] != null) {
      results = new List<MediaResults>();
      json['results'].forEach((v) {
        results.add(new MediaResults.fromJson(v));
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
  List<Terms> terms;

  Query({this.friendly, this.terms});

  Query.fromJson(Map<String, dynamic> json) {
    friendly = json['friendly'];
    if (json['terms'] != null) {
      terms = new List<Terms>();
      json['terms'].forEach((v) {
        terms.add(new Terms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['friendly'] = this.friendly;
    if (this.terms != null) {
      data['terms'] = this.terms.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Terms {
  String id;
  String operation;
  String value;

  Terms({this.id, this.operation, this.value});

  Terms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operation = json['operation'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['operation'] = this.operation;
    data['value'] = this.value;
    return data;
  }
}

class MediaResults {
  Datatype datatype;
  String collectionid;
  String id;
  Datatype entitysourcetype;
  String name;
  String sourcepath;
  String hasfulltext;

  MediaResults({this.datatype, this.collectionid, this.id, this.entitysourcetype, this.name, this.sourcepath, this.hasfulltext});

  MediaResults.fromJson(Map<String, dynamic> json) {
    datatype = json['datatype'] != null ? new Datatype.fromJson(json['datatype']) : null;
    collectionid = json['collectionid'];
    id = json['id'];
    entitysourcetype = json['entitysourcetype'] != null ? new Datatype.fromJson(json['entitysourcetype']) : null;
    name = json['name'];
    sourcepath = json['sourcepath'];
    hasfulltext = json['hasfulltext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datatype != null) {
      data['datatype'] = this.datatype.toJson();
    }
    data['collectionid'] = this.collectionid;
    data['id'] = this.id;
    if (this.entitysourcetype != null) {
      data['entitysourcetype'] = this.entitysourcetype.toJson();
    }
    data['name'] = this.name;
    data['sourcepath'] = this.sourcepath;
    data['hasfulltext'] = this.hasfulltext;
    return data;
  }
}

class Datatype {
  String id;
  String name;

  Datatype({this.id, this.name});

  Datatype.fromJson(Map<String, dynamic> json) {
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
