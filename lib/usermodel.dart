class UserModel{
  String? uid;
  String? name;
  String? email;
  String? profilLink;

  UserModel({this.uid,this.name,this.email,this.profilLink});
  UserModel.fromMap(Map<String , dynamic> map){
    uid=map["uid"];
    name=map["name"];
    email=map["email"];
    profilLink=map["profilLink"];
  }


  Map<String,dynamic> toMap(){
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "profilLink": profilLink,
    };
  }

}