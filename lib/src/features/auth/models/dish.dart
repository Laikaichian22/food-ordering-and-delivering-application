
class DishModel{
  int dishId ;
  String dishSpcId;
  String dishName;
  String dishPhoto;
  bool? isSelected;

  DishModel({
    required this.dishId,
    required this.dishSpcId,
    required this.dishName,
    required this.dishPhoto,
    this.isSelected = false,
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