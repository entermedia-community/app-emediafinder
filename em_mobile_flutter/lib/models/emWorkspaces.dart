import 'dart:convert';
//todo; NOTE: Don't touch make copy!
EmWorkspaces emWorkspacesFromJson(String str) => EmWorkspaces.fromJson(json.decode(str));

String emWorkspacesToJson(EmWorkspaces data) => json.encode(data.toJson());

class EmWorkspaces {
  EmWorkspaces({
    this.response,
    this.results,
  });

  Response response;
  List<Result> results;

  factory EmWorkspaces.fromJson(Map<String, dynamic> json) => EmWorkspaces(
    response: Response.fromJson(json["response"]),
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Response {
  Response({
    this.status,
    this.userid,
    this.totalhits,
    this.searchtype,
    this.hitsperpage,
    this.page,
    this.pages,
    this.hitsessionid,
    this.query,
  });

  String status;
  String userid;
  int totalhits;
  String searchtype;
  int hitsperpage;
  int page;
  int pages;
  String hitsessionid;
  Query query;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    status: json["status"],
    userid: json["userid"],
    totalhits: json["totalhits"],
    searchtype: json["searchtype"],
    hitsperpage: json["hitsperpage"],
    page: json["page"],
    pages: json["pages"],
    hitsessionid: json["hitsessionid"],
    query: Query.fromJson(json["query"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "userid": userid,
    "totalhits": totalhits,
    "searchtype": searchtype,
    "hitsperpage": hitsperpage,
    "page": page,
    "pages": pages,
    "hitsessionid": hitsessionid,
    "query": query.toJson(),
  };
}

class Query {
  Query({
    this.friendly,
    this.search,
  });

  String friendly;
  String search;

  factory Query.fromJson(Map<String, dynamic> json) => Query(
    friendly: json["friendly"],
    search: json["search"],
  );

  Map<String, dynamic> toJson() => {
    "friendly": friendly,
    "search": search,
  };
}

class Result {
  Result({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

}
