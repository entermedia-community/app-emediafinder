class GetWorkspaceModel {
  Response response;
  List<Results> results;

  GetWorkspaceModel({this.response, this.results});

  GetWorkspaceModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? new Response.fromJson(json['response']) : null;
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
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
  String userid;
  int totalhits;
  String searchtype;
  int hitsperpage;
  int page;
  int pages;
  String hitsessionid;
  Query query;

  Response({this.status, this.userid, this.totalhits, this.searchtype, this.hitsperpage, this.page, this.pages, this.hitsessionid, this.query});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userid = json['userid'];
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
    data['userid'] = this.userid;
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

class Results {
  String id;
  String name;
  List<Servers> servers;

  Results({this.id, this.name, this.servers});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['servers'] != null) {
      servers = new List<Servers>();
      json['servers'].forEach((v) {
        servers.add(new Servers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.servers != null) {
      data['servers'] = this.servers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Servers {
  String id;
  String name;
  Librarycollection librarycollection;
  Librarycollection owner;
  String datestart;
  String dateend;
  Librarycollection instanceStatus;
  String istrial;
  String instanceurl;
  String instanceprefix;
  String instancename;
  String instancenode;
  Librarycollection entermediaServers;
  String inbackuppc;
  String syncpriority;

  Servers(
      {this.id,
      this.name,
      this.librarycollection,
      this.owner,
      this.datestart,
      this.dateend,
      this.instanceStatus,
      this.istrial,
      this.instanceurl,
      this.instanceprefix,
      this.instancename,
      this.instancenode,
      this.entermediaServers,
      this.inbackuppc,
      this.syncpriority});

  Servers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    librarycollection = json['librarycollection'] != null ? new Librarycollection.fromJson(json['librarycollection']) : null;
    owner = json['owner'] != null ? new Librarycollection.fromJson(json['owner']) : null;
    datestart = json['datestart'];
    dateend = json['dateend'];
    instanceStatus = json['instance_status'] != null ? new Librarycollection.fromJson(json['instance_status']) : null;
    istrial = json['istrial'];
    instanceurl = json['instanceurl'];
    instanceprefix = json['instanceprefix'];
    instancename = json['instancename'];
    instancenode = json['instancenode'];
    entermediaServers = json['entermedia_servers'] != null ? new Librarycollection.fromJson(json['entermedia_servers']) : null;
    inbackuppc = json['inbackuppc'];
    syncpriority = json['syncpriority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.librarycollection != null) {
      data['librarycollection'] = this.librarycollection.toJson();
    }
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['datestart'] = this.datestart;
    data['dateend'] = this.dateend;
    if (this.instanceStatus != null) {
      data['instance_status'] = this.instanceStatus.toJson();
    }
    data['istrial'] = this.istrial;
    data['instanceurl'] = this.instanceurl;
    data['instanceprefix'] = this.instanceprefix;
    data['instancename'] = this.instancename;
    data['instancenode'] = this.instancenode;
    if (this.entermediaServers != null) {
      data['entermedia_servers'] = this.entermediaServers.toJson();
    }
    data['inbackuppc'] = this.inbackuppc;
    data['syncpriority'] = this.syncpriority;
    return data;
  }
}

class Librarycollection {
  String id;
  String name;

  Librarycollection({this.id, this.name});

  Librarycollection.fromJson(Map<String, dynamic> json) {
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
