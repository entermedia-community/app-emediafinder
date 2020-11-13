// To parse this JSON data, do
//
//     final workspace = workspaceFromJson(jsonString);

import 'dart:convert';

Workspace workspaceFromJson(String str) => Workspace.fromJson(json.decode(str));

String workspaceToJson(Workspace data) => json.encode(data.toJson());

class Workspace {
  Workspace({
    this.page,
    this.hitsperpage,
    this.query,
  });

  String page;
  String hitsperpage;
  Query query;

  factory Workspace.fromJson(Map<String, dynamic> json) => Workspace(
    page: json["page"],
    hitsperpage: json["hitsperpage"],
    query: Query.fromJson(json["query"]),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "hitsperpage": hitsperpage,
    "query": query.toJson(),
  };
}

class Query {
  Query({
    this.terms,
  });

  List<Term> terms;

  factory Query.fromJson(Map<String, dynamic> json) => Query(
    terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
  };
}

class Term {
  Term({
    this.field,
    this.termOperator,
    this.value,
  });

  String field;
  String termOperator;
  String value;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    field: json["field"],
    termOperator: json["operator"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "field": field,
    "operator": termOperator,
    "value": value,
  };
}
