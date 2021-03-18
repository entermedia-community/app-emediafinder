class UploadMediaModel {
  Response response;
  Data data;

  UploadMediaModel({this.response, this.data});

  UploadMediaModel.fromJson(Map<String, dynamic> json) {
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
  Datatype datatype;
  String id;
  String name;
  String sourcepath;
  String isfolder;
  String assetviews;
  Datatype fileformat;
  String assetmodificationdate;
  String assetaddeddate;
  Datatype owner;
  String primaryfile;
  Datatype importstatus;
  Datatype previewstatus;
  Datatype editstatus;
  String islocked;
  Datatype pushstatus;

  Data(
      {this.datatype,
      this.id,
      this.name,
      this.sourcepath,
      this.isfolder,
      this.assetviews,
      this.fileformat,
      this.assetmodificationdate,
      this.assetaddeddate,
      this.owner,
      this.primaryfile,
      this.importstatus,
      this.previewstatus,
      this.editstatus,
      this.islocked,
      this.pushstatus});

  Data.fromJson(Map<String, dynamic> json) {
    datatype = json['datatype'] != null ? new Datatype.fromJson(json['datatype']) : null;
    id = json['id'];
    name = json['name'];
    sourcepath = json['sourcepath'];
    isfolder = json['isfolder'];
    assetviews = json['assetviews'];
    fileformat = json['fileformat'] != null ? new Datatype.fromJson(json['fileformat']) : null;
    assetmodificationdate = json['assetmodificationdate'];
    assetaddeddate = json['assetaddeddate'];
    owner = json['owner'] != null ? new Datatype.fromJson(json['owner']) : null;
    primaryfile = json['primaryfile'];
    importstatus = json['importstatus'] != null ? new Datatype.fromJson(json['importstatus']) : null;
    previewstatus = json['previewstatus'] != null ? new Datatype.fromJson(json['previewstatus']) : null;
    editstatus = json['editstatus'] != null ? new Datatype.fromJson(json['editstatus']) : null;
    islocked = json['islocked'];
    pushstatus = json['pushstatus'] != null ? new Datatype.fromJson(json['pushstatus']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datatype != null) {
      data['datatype'] = this.datatype.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['sourcepath'] = this.sourcepath;
    data['isfolder'] = this.isfolder;
    data['assetviews'] = this.assetviews;
    if (this.fileformat != null) {
      data['fileformat'] = this.fileformat.toJson();
    }
    data['assetmodificationdate'] = this.assetmodificationdate;
    data['assetaddeddate'] = this.assetaddeddate;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['primaryfile'] = this.primaryfile;
    if (this.importstatus != null) {
      data['importstatus'] = this.importstatus.toJson();
    }
    if (this.previewstatus != null) {
      data['previewstatus'] = this.previewstatus.toJson();
    }
    if (this.editstatus != null) {
      data['editstatus'] = this.editstatus.toJson();
    }
    data['islocked'] = this.islocked;
    if (this.pushstatus != null) {
      data['pushstatus'] = this.pushstatus.toJson();
    }
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
