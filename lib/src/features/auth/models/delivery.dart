
class DeliveryModel{
  String? platNum;
  String? currLocation;
  String? nextLocation;
  String? startTime;
  String? extimatedTime;
  String? messageSent;
  

  DeliveryModel({
    this.platNum,
    this.currLocation,
    this.nextLocation,
    this.startTime,
    this.extimatedTime,
    this.messageSent
  });

  Map<String, dynamic> toDeliveryJason(){
    return{
      'platNumber' : platNum,
      'currLocation' : currLocation,
      'nextLocation' : nextLocation,
      'startTime' : startTime,
      'extimatedTime' : extimatedTime,
      'messageSent' : messageSent
    };
  }

  DeliveryModel.fromMap(Map<String, dynamic> deliveryMap)
  : platNum = deliveryMap['platNumber'],
    currLocation = deliveryMap['currLocation'],
    nextLocation = deliveryMap['nextLocation'],
    startTime = deliveryMap['startTime'],
    extimatedTime = deliveryMap['extimatedTime'],
    messageSent = deliveryMap['messageSent'];


}