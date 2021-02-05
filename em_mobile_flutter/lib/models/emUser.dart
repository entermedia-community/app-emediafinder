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
        user: json["user"] == null ? null : json["user"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user": user == null ? null : user,
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
        entermediakey: json["entermediakey"] == null ? null : json["entermediakey"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        email: json["email"] == null ? null : json["email"],
        firebasepassword: json["firebasepassword"] == null ? null : json["firebasepassword"],
        userid: json["userid"] == null ? null : json["userid"],
        screenname: json["screenname"] == null ? null : json["screenname"],
      );

  Map<String, dynamic> toJson() => {
        "entermediakey": entermediakey == null ? null : entermediakey,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "email": email == null ? null : email,
        "firebasepassword": firebasepassword == null ? null : firebasepassword,
        "userid": userid == null ? null : userid,
        "screenname": screenname == null ? null : screenname,
      };
}
