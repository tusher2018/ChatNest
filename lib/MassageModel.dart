import 'package:cloud_firestore/cloud_firestore.dart';

class MassageModel{

  String? massageId;
  String? sender;
  String? massage;
  bool? seen;
  DateTime? time;

  MassageModel({this.sender,this.massage,this.seen,this.time,this.massageId});
  MassageModel.fromMap(Map<String , dynamic> map){
    sender=map["sender"];
    massage=map["massage"];
    seen=map["seen"];
    time=(map['time'] as Timestamp).toDate();
    massageId=map["massageId"];
  }

  Map<String,dynamic> toMap(){
    return {
      "sender": sender,
      "massage": massage,
      "seen": seen,
      "time": time,
      "massageId":massageId
    };
  }


}