
class DishModel{
  int dishId ;
  String dishSpcId;
  String dishName;
  String dishPhoto;

  DishModel({
    required this.dishId,
    required this.dishSpcId,
    required this.dishName,
    required this.dishPhoto,
  });


  Map<String, dynamic> toDishJason(){
   return{
    'dishId' : dishId,
    'dishSpecial Id' : dishSpcId,
    'dishName' : dishName,
    'dishPhoto' : dishPhoto,
   };
  }


  DishModel.fromMap(Map<String, dynamic> dishMap)
  : dishId = dishMap['dishId'],
    dishSpcId = dishMap['dishSpecial Id'],
    dishName = dishMap['dishName'],
    dishPhoto = dishMap['dishPhoto'];


}