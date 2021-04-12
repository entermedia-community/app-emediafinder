class MediaAssetModel {
  Response response;
  List<MediaResults> results;

  MediaAssetModel({this.response, this.results});

  MediaAssetModel.fromJson(Map<String, dynamic> json) {
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
  String id;
  String googletagged;
  String googletranscoded;
  Datatype entitysourcetype;
  Datatype entityproject;
  Datatype entityevent;
  String name;
  String sourcepath;
  String foldersourcepath;

  String isfolder;

  Datatype assettype;
  String hasfulltext;
  String pages;
  String assetviews;
  String assetvotes;
  String focallength;
  String iso;
  String shutterspeed;
  String aperture;
  String bitspersample;
  Datatype imageorientation;
  Datatype fileformat;
  String detectedfileformat;
  String filesize;
  String width;
  String height;
  String assetcreationdate;
  String assetmodificationdate;
  String assetaddeddate;
  Datatype owner;
  String primaryfile;
  Datatype importstatus;
  Datatype previewstatus;
  Datatype editstatus;
  String facescancomplete;
  String facehasprofile;
  String facematchcomplete;
  String publisheds3;
  String md5hex;
  String duplicate;
  String duplicatesourcepath;
  String assetexpired;
  String haschat;
  String islocked;
  String deleted;
  String emidwritten;
  String emiderror;
  String xmperror;
  String missinggenerated;
  String emrecordstatus;
  Datatype pushstatus;
  String existsonpush;
  String fromviz;
  List<Downloads> downloads;

  MediaResults(
      {this.datatype,
      this.id,
      this.googletagged,
      this.googletranscoded,
      this.entitysourcetype,
      this.entityproject,
      this.entityevent,
      this.name,
      this.sourcepath,
      this.foldersourcepath,
      this.isfolder,
      this.assettype,
      this.hasfulltext,
      this.pages,
      this.assetviews,
      this.assetvotes,
      this.focallength,
      this.iso,
      this.shutterspeed,
      this.aperture,
      this.bitspersample,
      this.imageorientation,
      this.fileformat,
      this.detectedfileformat,
      this.filesize,
      this.width,
      this.height,
      this.assetcreationdate,
      this.assetmodificationdate,
      this.assetaddeddate,
      this.owner,
      this.primaryfile,
      this.importstatus,
      this.previewstatus,
      this.editstatus,
      this.facescancomplete,
      this.facehasprofile,
      this.facematchcomplete,
      this.publisheds3,
      this.md5hex,
      this.duplicate,
      this.duplicatesourcepath,
      this.assetexpired,
      this.haschat,
      this.islocked,
      this.deleted,
      this.emidwritten,
      this.emiderror,
      this.xmperror,
      this.missinggenerated,
      this.emrecordstatus,
      this.pushstatus,
      this.existsonpush,
      this.fromviz,
      this.downloads});

  MediaResults.fromJson(Map<String, dynamic> json) {
    datatype = json['datatype'] != null ? new Datatype.fromJson(json['datatype']) : null;
    id = json['id'];
    googletagged = json['googletagged'];
    googletranscoded = json['googletranscoded'];
    entitysourcetype = json['entitysourcetype'] != null ? new Datatype.fromJson(json['entitysourcetype']) : null;
    entityproject = json['entityproject'] != null ? new Datatype.fromJson(json['entityproject']) : null;
    entityevent = json['entityevent'] != null ? new Datatype.fromJson(json['entityevent']) : null;
    name = json['name'];
    sourcepath = json['sourcepath'];
    foldersourcepath = json['foldersourcepath'];

    isfolder = json['isfolder'];

    assettype = json['assettype'] != null ? new Datatype.fromJson(json['assettype']) : null;
    hasfulltext = json['hasfulltext'];
    pages = json['pages'];
    assetviews = json['assetviews'];
    assetvotes = json['assetvotes'];
    focallength = json['focallength'];
    iso = json['iso'];
    shutterspeed = json['shutterspeed'];
    aperture = json['aperture'];
    bitspersample = json['bitspersample'];
    imageorientation = json['imageorientation'] != null ? new Datatype.fromJson(json['imageorientation']) : null;
    fileformat = json['fileformat'] != null ? new Datatype.fromJson(json['fileformat']) : null;
    detectedfileformat = json['detectedfileformat'];
    filesize = json['filesize'];
    width = json['width'];
    height = json['height'];
    assetcreationdate = json['assetcreationdate'];
    assetmodificationdate = json['assetmodificationdate'];
    assetaddeddate = json['assetaddeddate'];
    owner = json['owner'] != null ? new Datatype.fromJson(json['owner']) : null;
    primaryfile = json['primaryfile'];
    importstatus = json['importstatus'] != null ? new Datatype.fromJson(json['importstatus']) : null;
    previewstatus = json['previewstatus'] != null ? new Datatype.fromJson(json['previewstatus']) : null;
    editstatus = json['editstatus'] != null ? new Datatype.fromJson(json['editstatus']) : null;
    facescancomplete = json['facescancomplete'];
    facehasprofile = json['facehasprofile'];
    facematchcomplete = json['facematchcomplete'];
    publisheds3 = json['publisheds3'];
    md5hex = json['md5hex'];
    duplicate = json['duplicate'];
    duplicatesourcepath = json['duplicatesourcepath'];

    assetexpired = json['assetexpired'];
    haschat = json['haschat'];
    islocked = json['islocked'];
    deleted = json['deleted'];
    emidwritten = json['emidwritten'];
    emiderror = json['emiderror'];
    xmperror = json['xmperror'];
    missinggenerated = json['missinggenerated'];
    emrecordstatus = json['emrecordstatus'];
    pushstatus = json['pushstatus'] != null ? new Datatype.fromJson(json['pushstatus']) : null;
    existsonpush = json['existsonpush'];
    fromviz = json['fromviz'];
    if (json['downloads'] != null) {
      downloads = new List<Downloads>();
      json['downloads'].forEach((v) {
        downloads.add(new Downloads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datatype != null) {
      data['datatype'] = this.datatype.toJson();
    }
    data['id'] = this.id;
    data['googletagged'] = this.googletagged;
    data['googletranscoded'] = this.googletranscoded;
    if (this.entitysourcetype != null) {
      data['entitysourcetype'] = this.entitysourcetype.toJson();
    }
    if (this.entityproject != null) {
      data['entityproject'] = this.entityproject.toJson();
    }
    if (this.entityevent != null) {
      data['entityevent'] = this.entityevent.toJson();
    }
    data['name'] = this.name;
    data['sourcepath'] = this.sourcepath;
    data['foldersourcepath'] = this.foldersourcepath;

    data['isfolder'] = this.isfolder;

    if (this.assettype != null) {
      data['assettype'] = this.assettype.toJson();
    }
    data['hasfulltext'] = this.hasfulltext;
    data['pages'] = this.pages;
    data['assetviews'] = this.assetviews;
    data['assetvotes'] = this.assetvotes;
    data['focallength'] = this.focallength;
    data['iso'] = this.iso;
    data['shutterspeed'] = this.shutterspeed;
    data['aperture'] = this.aperture;
    data['bitspersample'] = this.bitspersample;
    if (this.imageorientation != null) {
      data['imageorientation'] = this.imageorientation.toJson();
    }
    if (this.fileformat != null) {
      data['fileformat'] = this.fileformat.toJson();
    }
    data['detectedfileformat'] = this.detectedfileformat;
    data['filesize'] = this.filesize;
    data['width'] = this.width;
    data['height'] = this.height;
    data['assetcreationdate'] = this.assetcreationdate;
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
    data['facescancomplete'] = this.facescancomplete;
    data['facehasprofile'] = this.facehasprofile;
    data['facematchcomplete'] = this.facematchcomplete;
    data['publisheds3'] = this.publisheds3;
    data['md5hex'] = this.md5hex;
    data['duplicate'] = this.duplicate;
    data['duplicatesourcepath'] = this.duplicatesourcepath;

    data['assetexpired'] = this.assetexpired;
    data['haschat'] = this.haschat;
    data['islocked'] = this.islocked;
    data['deleted'] = this.deleted;
    data['emidwritten'] = this.emidwritten;
    data['emiderror'] = this.emiderror;
    data['xmperror'] = this.xmperror;
    data['missinggenerated'] = this.missinggenerated;
    data['emrecordstatus'] = this.emrecordstatus;
    if (this.pushstatus != null) {
      data['pushstatus'] = this.pushstatus.toJson();
    }
    data['existsonpush'] = this.existsonpush;
    data['fromviz'] = this.fromviz;
    if (this.downloads != null) {
      data['downloads'] = this.downloads.map((v) => v.toJson()).toList();
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

class Downloads {
  String name;
  String id;
  String url;

  Downloads({this.name, this.id, this.url});

  Downloads.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}
