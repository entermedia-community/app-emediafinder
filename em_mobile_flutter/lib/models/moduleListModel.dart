class ModuleListModel {
  ModuleListResponse response;
  List<ModuleListResults> results;

  ModuleListModel({this.response, this.results});

  ModuleListModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? new ModuleListResponse.fromJson(json['response']) : null;
    if (json['results'] != null) {
      results = <ModuleListResults>[];
      json['results'].forEach((v) {
        results.add(new ModuleListResults.fromJson(v));
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

class ModuleListResponse {
  String status;
  int totalhits;
  String searchtype;
  int hitsperpage;
  int page;
  int pages;
  String hitsessionid;
  Query query;

  ModuleListResponse({this.status, this.totalhits, this.searchtype, this.hitsperpage, this.page, this.pages, this.hitsessionid, this.query});

  ModuleListResponse.fromJson(Map<String, dynamic> json) {
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

class ModuleListResults {
  String id;
  String name;
  String isentity;
  String showonnav;
  String showonsearch;
  String ordering;
  String securityenabled;
  String modulerendertype;
  String moduleicon;
  String href;

  ModuleListResults(
      {this.id,
      this.name,
      this.isentity,
      this.showonnav,
      this.showonsearch,
      this.ordering,
      this.securityenabled,
      this.modulerendertype,
      this.moduleicon,
      this.href});

  ModuleListResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isentity = json['isentity'];
    showonnav = json['showonnav'];
    showonsearch = json['showonsearch'];
    ordering = json['ordering'];
    securityenabled = json['securityenabled'];
    modulerendertype = json['modulerendertype'];
    moduleicon = json['moduleicon'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isentity'] = this.isentity;
    data['showonnav'] = this.showonnav;
    data['showonsearch'] = this.showonsearch;
    data['ordering'] = this.ordering;
    data['securityenabled'] = this.securityenabled;
    data['modulerendertype'] = this.modulerendertype;
    data['moduleicon'] = this.moduleicon;
    data['href'] = this.href;
    return data;
  }
}
