class ChatRoomModel{
  String? roomId;
  Map<String,dynamic>? participants;
  String? lastMassage;

  ChatRoomModel({this.roomId,this.participants,this.lastMassage});
  ChatRoomModel.fromMap(Map<String , dynamic> map){
    roomId=map["roomId"];
    participants=map["participants"];
    lastMassage=map["lastMassage"];
  }

  Map<String,dynamic> toMap(){
    return {
      "roomId": roomId,
      "participants": participants,
      "lastMassage":lastMassage
    };
  }

}