import 'package:flutter/material.dart';

class WorkspaceAssetsModel with ChangeNotifier {
  WorkspaceAssetsModel({
    this.organizedhits,
    this.response,
  });

  List<Organizedhit> organizedhits;
  Response response;

  factory WorkspaceAssetsModel.fromJson(Map<String, dynamic> json) => WorkspaceAssetsModel(
        organizedhits: List<Organizedhit>.from(json["organizedhits"].map((x) => Organizedhit.fromJson(x))),
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "organizedhits": List<dynamic>.from(organizedhits.map((x) => x.toJson())),
        "response": response.toJson(),
      };
}

class Organizedhit {
  Organizedhit({
    this.name,
    this.id,
    this.samplecount,
    this.sampletotal,
    this.samples,
  });

  String name;
  String id;
  String samplecount;
  String sampletotal;
  List<Sample> samples;

  factory Organizedhit.fromJson(Map<String, dynamic> json) => Organizedhit(
        name: json["name"],
        id: json["id"],
        samplecount: json["samplecount"],
        sampletotal: json["sampletotal"],
        samples: List<Sample>.from(json["samples"].map((x) => Sample.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "samplecount": samplecount,
        "sampletotal": sampletotal,
        "samples": List<dynamic>.from(samples.map((x) => x.toJson())),
      };
}

class Sample {
  Sample({
    this.collectionid,
    this.id,
    this.name,
    this.thumbnailimg,
    this.entitysourcetype,
    this.hasfulltext,
    this.parentid,
    this.parents,
    this.categorypath,
    this.autocreatecollections,
    this.viewusers,
    this.entityDate,
  });

  String collectionid;
  String id;
  String name;
  String thumbnailimg;
  Entitysourcetype entitysourcetype;
  String hasfulltext;
  Entitysourcetype parentid;
  Entitysourcetype parents;
  String categorypath;
  String autocreatecollections;
  List<Entitysourcetype> viewusers;
  DateTime entityDate;

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
        collectionid: json["collectionid"] == null ? null : json["collectionid"],
        id: json["id"],
        name: json["name"],
        thumbnailimg: json["thumbnailimg"] == null ? null : json["thumbnailimg"],
        entitysourcetype: json["entitysourcetype"] == null ? null : Entitysourcetype.fromJson(json["entitysourcetype"]),
        hasfulltext: json["hasfulltext"] == null ? null : json["hasfulltext"],
        parentid: json["parentid"] == null ? null : Entitysourcetype.fromJson(json["parentid"]),
        parents: json["parents"] == null ? null : Entitysourcetype.fromJson(json["parents"]),
        categorypath: json["categorypath"] == null ? null : json["categorypath"],
        autocreatecollections: json["autocreatecollections"] == null ? null : json["autocreatecollections"],
        viewusers: json["viewusers"] == null ? null : List<Entitysourcetype>.from(json["viewusers"].map((x) => Entitysourcetype.fromJson(x))),
        entityDate: json["entity_date"] == null ? null : DateTime.parse(json["entity_date"]),
      );

  Map<String, dynamic> toJson() => {
        "collectionid": collectionid == null ? null : collectionid,
        "id": id,
        "name": name,
        "thumbnailimg": thumbnailimg == null ? null : thumbnailimg,
        "entitysourcetype": entitysourcetype == null ? null : entitysourcetype.toJson(),
        "hasfulltext": hasfulltext == null ? null : hasfulltext,
        "parentid": parentid == null ? null : parentid.toJson(),
        "parents": parents == null ? null : parents.toJson(),
        "categorypath": categorypath == null ? null : categorypath,
        "autocreatecollections": autocreatecollections == null ? null : autocreatecollections,
        "viewusers": viewusers == null ? null : List<dynamic>.from(viewusers.map((x) => x.toJson())),
        "entity_date": entityDate == null ? null : entityDate.toIso8601String(),
      };
}

class Entitysourcetype {
  Entitysourcetype({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Entitysourcetype.fromJson(Map<String, dynamic> json) => Entitysourcetype(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Response {
  Response({
    this.status,
    this.page,
    this.pages,
    this.totalhits,
    this.hitsessionid,
    this.query,
  });

  String status;
  int page;
  int pages;
  int totalhits;
  String hitsessionid;
  Query query;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        page: json["page"],
        pages: json["pages"],
        totalhits: json["totalhits"],
        hitsessionid: json["hitsessionid"],
        query: Query.fromJson(json["query"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "page": page,
        "pages": pages,
        "totalhits": totalhits,
        "hitsessionid": hitsessionid,
        "query": query.toJson(),
      };
}

class Query {
  Query({
    this.friendly,
    this.terms,
  });

  String friendly;
  List<Term> terms;

  factory Query.fromJson(Map<String, dynamic> json) => Query(
        friendly: json["friendly"],
        terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "friendly": friendly,
        "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
      };
}

class Term {
  Term({
    this.id,
    this.operation,
    this.value,
  });

  String id;
  String operation;
  String value;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        id: json["id"],
        operation: json["operation"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "operation": operation,
        "value": value,
      };
}
