import 'dart:convert';
//todo; NOTE: Don't touch make copy!
EmUser emUserFromJson(String str) => EmUser.fromJson(json.decode(str));

String emUserToJson(EmUser data) => json.encode(data.toJson());

class EmUser {
  EmUser({
    this.response,
    this.results,
  });

  Response response;
  Results results;

  factory EmUser.fromJson(Map<String, dynamic> json) => EmUser(
    response: Response.fromJson(json["response"]),
    results: Results.fromJson(json["results"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response.toJson(),
    "results": results.toJson(),
  };
}

class Response {
  Response({
    this.status,
    this.user,
  });

  String status;
  String user;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    status: json["status"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user,
  };
}

class Results {
  Results({
    this.entermediakey,
    this.firstname,
    this.lastname,
    this.email,
    this.firebasepassword,
    this.userid,
    this.screenname,
  });

  String entermediakey;
  String firstname;
  String lastname;
  String email;
  String firebasepassword;
  String userid;
  String screenname;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    entermediakey: json["entermediakey"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    firebasepassword: json["firebasepassword"],
    userid: json["userid"],
    screenname: json["screenname"],
  );

  Map<String, dynamic> toJson() => {
    "entermediakey": entermediakey,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "firebasepassword": firebasepassword,
    "userid": userid,
    "screenname": screenname,
  };
}